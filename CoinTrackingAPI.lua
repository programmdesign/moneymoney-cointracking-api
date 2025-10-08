-- Inofficial CoinTracking Extension (www.cointracking.info) for MoneyMoney
-- Version 1.0
-- License: MIT
-- Author: Christoph Neumann (@programmdesign), Gemini, ChatGPT
-- 
-- Fetches gains/balances from the CoinTracking API and displays them as a portfolio.
--
-- Username: CoinTracking API Key
-- Password: CoinTracking API Secret

WebBanking{
    version     = 1.0,
    url         = "https://cointracking.info/api/v1/",
    services    = {"CoinTracking API"},
    description = "Retrieves balances from the CoinTracking API and displays them as a portfolio."

}

local apiKey
local apiSecret
local cryptoCurrencies = {
    ["1INCH"] = "1inch Network",
    ["AAVE"] = "Aave",
    ["ADA"] = "Cardano",
    ["AEON"] = "Aeon",
    ["AGIX"] = "SingularityNET",
    ["AIOZ"] = "AIOZ Network",
    ["AKT"] = "Akash Network",
    ["ALGO"] = "Algorand",
    ["ANKR"] = "Ankr",
    ["ANT"] = "Aragon",
    ["AION"] = "Aion",
    ["APT"] = "Aptos",
    ["AR"] = "Arweave",
    ["ARB"] = "Arbitrum",
    ["ARDR"] = "Ardor",
    ["ARK"] = "Ark",
    ["AST"] = "AirSwap",
    ["ATOM2"] = "Cosmos",
    ["AVAX"] = "Avalanche",
    ["AXS"] = "Axie Infinity",
    ["BAT"] = "Basic Attention Token",
    ["BCD"] = "Bitcoin Diamond",
    ["BCH"] = "Bitcoin Cash",
    ["BCN"] = "Bytecoin",
    ["BEAM"] = "Beam",
    ["BLOCK"] = "Blocknet",
    ["BLZ"] = "Bluzelle",
    ["BNB"] = "BNB",
    ["BNT"] = "Bancor",
    ["BONK"] = "Bonk",
    ["BTC"] = "Bitcoin",
    ["BTG"] = "Bitcoin Gold",
    ["BTS"] = "BitShares",
    ["BTT"] = "BitTorrent",
    ["CDT"] = "Blox",
    ["CELO"] = "Celo",
    ["CHZ"] = "Chiliz",
    ["CLOAK"] = "CloakCoin",
    ["COMP"] = "Compound",
    ["CPOOL"] = "Clearpool",
    ["CRO"] = "Cronos",
    ["CRV"] = "Curve DAO Token",
    ["CSPR"] = "Casper",
    ["CVC"] = "Civic",
    ["CVX"] = "Convex Finance",
    ["DAI"] = "Dai",
    ["DAO"] = "DAO Maker",
    ["DCR"] = "Decred",
    ["DGB"] = "DigiByte",
    ["DNT"] = "district0x",
    ["DOCK"] = "Dock",
    ["DOGE"] = "Dogecoin",
    ["DOT2"] = "Polkadot",
    ["DYDX"] = "dYdX",
    ["EGLD"] = "MultiversX",
    ["ELF"] = "aelf",
    ["ENA"] = "Ethena",
    ["ENJ"] = "Enjin Coin",
    ["EOS"] = "EOS",
    ["ETC"] = "Ethereum Classic",
    ["ETH"] = "Ethereum",
    ["FCT"] = "Factom",
    ["FET"] = "Fetch.ai",
    ["FIL"] = "Filecoin",
    ["FLOKI"] = "FLOKI",
    ["FLOW"] = "Flow",
    ["FTM"] = "Fantom",
    ["FUEL"] = "Etherparty",
    ["FUN"] = "FunFair",
    ["GALA"] = "Gala",
    ["GNO"] = "Gnosis",
    ["GO"] = "GoChain",
    ["GRS"] = "Groestlcoin",
    ["GRT"] = "The Graph",
    ["HBAR"] = "Hedera",
    ["HIVE"] = "Hive",
    ["HOT"] = "Holo",
    ["HYPE"] = "Hyperliquid",
    ["ICP2"] = "Internet Computer",
    ["ICX"] = "ICON",
    ["IMX"] = "Immutable",
    ["INJ"] = "Injective",
    ["IOTX"] = "IoTeX",
    ["JASMY"] = "JasmyCoin",
    ["JUP"] = "Jupiter",
    ["KAS"] = "Kaspa",
    ["KAVA"] = "Kava",
    ["KDA"] = "Kadena",
    ["KMD"] = "Komodo",
    ["KNC"] = "Kyber Network",
    ["KYL"] = "Kylin",    
    ["LDO"] = "Lido DAO",
    ["LEO"] = "UNUS SED LEO",
    ["LINK"] = "Chainlink",
    ["LIT2"] = "Litentry",    
    ["LOOM"] = "Loom Network",
    ["LRC"] = "Loopring",
    ["LSK"] = "Lisk",
    ["LTC"] = "Litecoin",
    ["MAID"] = "MaidSafeCoin",
    ["MAN"] = "Matrix AI Network",
    ["MANA"] = "Decentraland",
    ["MINA"] = "Mina",    
    ["MCO"] = "MCO",
    ["MKR"] = "Maker",
    ["MLN"] = "Melon",
    ["MNT"] = "Mantle",
    ["MONA"] = "MonaCoin",
    ["MTH"] = "Monetha",
    ["MTL"] = "Metal",
    ["NANO"] = "Nano",
    ["NAS"] = "Nebulas",
    ["NAV"] = "NavCoin",
    ["NEAR"] = "NEAR Protocol",
    ["NEO"] = "Neo",
    ["NEXO"] = "Nexo",
    ["NXT"] = "Nxt",
    ["OKB"] = "OKB",
    ["OMG"] = "OMG Network",
    ["ONDO"] = "Ondo",
    ["OP"] = "Optimism",
    ["PART"] = "Particl",
    ["PAY"] = "TenX",
    ["PENDLE"] = "Pendle",
    ["PEPE"] = "Pepe",
    ["PIVX"] = "PIVX",
    ["POA"] = "POA Network",
    ["POL3"] = "Polygon",
    ["POLY"] = "Polymath",
    ["QKC"] = "QuarkChain",
    ["QNT"] = "Quant",
    ["QTUM"] = "Qtum",
    ["REP"] = "Augur",
    ["REQ"] = "Request",
    ["RLC"] = "iExec RLC",
    ["RNDR"] = "Render",
    ["ROSE"] = "Oasis Network",
    ["RUNE"] = "THORChain",
    ["RVN"] = "Ravencoin",
    ["SAND"] = "The Sandbox",
    ["SC"] = "Siacoin",
    ["SEI"] = "Sei",
    ["SHIB"] = "Shiba Inu",
    ["SMART"] = "SmartCash",
    ["SNT"] = "Status",
    ["SNX"] = "Synthetix",
    ["SOL2"] = "Solana",
    ["STEEM"] = "Steem",
    ["STETH"] = "Lido Staked Ether",
    ["STORJ"] = "Storj",
    ["STRAT"] = "Stratis",
    ["STRK2"] = "Starknet",
    ["SUB"] = "Substratum",
    ["SUI"] = "Sui",
    ["SUSHI"] = "SushiSwap",
    ["SXP"] = "Solar",
    ["SYS"] = "Syscoin",
    ["TAO"] = "Bittensor",
    ["THETA"] = "Theta Network",
    ["TIA"] = "Celestia",
    ["TOMO"] = "TomoChain",
    ["TON"] = "Toncoin",
    ["TRX"] = "TRON",
    ["UNI2"] = "Uniswap",
    ["USDC"] = "USDC",
    ["USDE"] = "Ethena USDe",
    ["USDT"] = "Tether USDT",
    ["VET"] = "VeChain",
    ["VIB"] = "Viberate",
    ["VTC"] = "Vertcoin",
    ["WAN"] = "Wanchain",
    ["WAVES"] = "Waves",
    ["WBTC"] = "Wrapped Bitcoin",
    ["WIF"] = "dogwifhat",
    ["WLD"] = "Worldcoin",
    ["WLFI"] = "World Liberty Financial",
    ["WTC"] = "Waltonchain",
    ["XDN"] = "DigitalNote",
    ["XEM"] = "NEM",
    ["XLM"] = "Stellar",
    ["XMR"] = "Monero",
    ["XRP"] = "Ripple",
    ["XTZ"] = "Tezos",
    ["XVG"] = "Verge",
    ["YFI"] = "yearn.finance",
    ["ZEC"] = "Zcash",
    ["ZEN"] = "Horizen",
    ["ZEUS7"] = "Zeus Network",
    ["ZIL"] = "Zilliqa",
    ["ZK3"] = "Polyhedra Network",
    ["ZRX"] = "0x"
}


-- ###########################################################################
-- ## Helpers
-- ###########################################################################

local function ToHex(bin)
  return (bin:gsub(".", function(c) return string.format("%02x", string.byte(c)) end))
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

local function CoinTrackingRequest(args)
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
  local resp = CoinTrackingRequest({ method = "getGains" }):dictionary()["gains"]

  local accountCurrency = tostring(resp["account_currency"])
  if accountCurrency == "" then accountCurrency = "EUR" end

  local balances = {}

  for k, v in pairs(resp) do
    local balance = {}
    balance["name"] = (cryptoCurrencies[tostring(v["coin"])] or tostring(v["coin"])) .. " (" .. v["coin"] .. ")"
    balance["quantity"] = tonumber(v["amount"])
    balance["purchasePrice"] = tonumber(v["cost_per_unit"])
    balance["price"] = tonumber(v["current_price"])
    balance["amount"] = tonumber(v["current_value"])
    balance["currencyOfPrice"] = string.upper(accountCurrency)
    balance["currencyOfPurchasePrice"] = string.upper(accountCurrency)
    balances[#balances+1] = balance
  end

  return balances
end
