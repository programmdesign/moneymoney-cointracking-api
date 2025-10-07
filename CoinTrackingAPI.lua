-- Inofficial Cointracking Extension (www.cointracking.info) for MoneyMoney
-- Version 1.0
-- License: MIT
-- Author: Christoph Neumann (@programmdesign), Gemini, ChatGPT
-- 
-- Fetches gains/balances from the Cointracking API and displays them as a portfolio.
--
-- Username: Cointracking API Key
-- Password: Cointracking API Secret

WebBanking{
    version     = 1.0,
    url         = "https://cointracking.info/api/v1/",
    services    = {"CoinTracking API"},
    description = "Retrieves balances from the CoinTracking API and displays them as a portfolio."

}

local apiKey
local apiSecret

-- ###########################################################################
-- ## Helpers
-- ###########################################################################

-- Hex-Encoder (MM.hmac512 liefert Binärdaten)
local function ToHex(bin)
  return (bin:gsub(".", function(c) return string.format("%02x", string.byte(c)) end))
end

-- Sichere String-/Zahl-Konvertierung (funktioniert für Node, String, Number)
local function ToString(v)
  if v == nil then return "" end
  local t = type(v)
  if t == "string" then return v end
  if t == "number" then return tostring(v) end
  if t == "userdata" and v.string then return v:string() end
  return tostring(v)
end

local function ToNumber(v)
  if v == nil then return 0 end
  local t = type(v)
  if t == "number" then return v end
  if t == "string" then return tonumber(v) or 0 end
  if t == "userdata" and v.string then return tonumber(v:string()) or 0 end
  return tonumber(v) or 0
end

-- ###########################################################################
-- ## MoneyMoney WebBanking Hooks
-- ###########################################################################

function SupportsBank(protocol, bankCode)
  return protocol == ProtocolWebBanking and bankCode == "CoinTracking API"
end

function InitializeSession(protocol, bankCode, username, username2, password, username3)
  apiKey = username
  apiSecret = password
end

function ListAccounts(knownAccounts)
  return {{ name = "CoinTracking", 
      accountNumber = "CoinTracking", 
      portfolio=true,
      type = AccountTypePortfolio,  
    }}
end

function RefreshAccount(account, since)
  return { securities = GetBalances()}
end

function EndSession()
  -- nothing to do
end

-- ###########################################################################
-- ## API
-- ###########################################################################

local function CointrackingRequest(args)
  local nonce = tostring(math.floor(MM.time() * 1000))
  local body  = "method=" .. args.method .. "&nonce=" .. nonce
  local sign  = ToHex(MM.hmac512(apiSecret, body))

  local headers = {
    ["Key"]    = apiKey,
    ["Sign"]   = sign,
    ["Accept"] = "application/json"
  }

  local conn = Connection()
  local content = conn:request(
    "POST",
    url,
    body,
    "application/x-www-form-urlencoded; charset=UTF-8",
    headers
  )
  print(content)

  if not content then
    error("Connection to CoinTracking API could not be established.")
  end

  if string.find(content, '"success":0') then
    local msg = string.match(content, '"error_msg":"([^"]+)"') or "Unknown API error."
    error("CoinTracking API error: " .. msg)
  end

  local json = JSON(content)
  if type(json) ~= "table" and type(json) ~= "userdata" then
    error("Unexpected error: The API response could not be processed. Content: " .. tostring(content))
  end

  print(json)
  return json
end

-- ###########################################################################
-- ## Public
-- ###########################################################################

function GetBalances()
  local resp = CointrackingRequest({ method = "getGains" }):dictionary()["gains"]

  local accountCurrency = ToString(resp["account_currency"])
  if accountCurrency == "" then accountCurrency = "EUR" end

  local balances = {}

  for k, v in pairs(resp) do
    local balance = {}
    balance["name"] = ToString(v["coin"]) 
    balance["quantity"] = ToNumber(v["amount"])
    balance["purchasePrice"] = ToNumber(v["cost_per_unit"])
    balance["price"] = ToNumber(v["current_price"])
    balance["amount"] = ToNumber(v["current_value"])
    balance["currencyOfPrice"] = string.upper(accountCurrency)
    balance["currencyOfPurchasePrice"] = string.upper(accountCurrency)
    balances[#balances+1] = balance
  end

  return balances
end

function GetTransactions(since)
  return {}
end

