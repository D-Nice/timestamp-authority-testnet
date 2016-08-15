// <ORACLIZE_API>
/*
Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani



Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

contract OraclizeI {
    address public cbAddress;
    function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
    function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
    function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
    function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
    function getPrice(string _datasource) returns (uint _dsprice);
    function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
    function useCoupon(string _coupon);
    function setProofType(byte _proofType);
    function createCoupon(string _code);
}
contract OraclizeAddrResolverI {
    function getAddress() returns (address _addr);
}
contract usingOraclize {
    uint constant day = 60*60*24;
    uint constant week = 60*60*24*7;
    uint constant month = 60*60*24*30;
    byte constant proofType_NONE = 0x00;
    byte constant proofType_TLSNotary = 0x10;
    byte constant proofStorage_IPFS = 0x01;
    uint8 constant networkID_mainnet = 1;
    uint8 constant networkID_testnet = 2;
    uint8 constant networkID_morden = 2;
    uint8 constant networkID_consensys = 161;
    
    OraclizeAddrResolverI OAR = OraclizeAddrResolverI(0x1d11e5eae3112dbd44f99266872ff1d07c77dce8);
    
    OraclizeI oraclize;
    modifier oraclizeAPI {
        oraclize = OraclizeI(OAR.getAddress());
        _
    }
    modifier coupon(string code){
        oraclize = OraclizeI(OAR.getAddress());
        oraclize.useCoupon(code);
        _
    }
    function oraclize_setNetwork(uint8 networkID) internal returns(bool){
        if (networkID == networkID_mainnet) OAR = OraclizeAddrResolverI(0x1d11e5eae3112dbd44f99266872ff1d07c77dce8);
        else if (networkID == networkID_testnet) OAR = OraclizeAddrResolverI(0x0ae06d5934fd75d214951eb96633fbd7f9262a7c);
        else if (networkID == networkID_consensys) OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
        else return false;
        return true;
    }
    function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(0, datasource, arg);
    }
    function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(timestamp, datasource, arg);
    }
    function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
    }
    function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
    }
    function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(0, datasource, arg1, arg2);
    }
    function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
    }
    function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
    }
    function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
    }
    function oraclize_cbAddress() oraclizeAPI internal returns (address){
        return oraclize.cbAddress();
    }
    function oraclize_setProof(byte proofP) oraclizeAPI internal {
        return oraclize.setProofType(proofP);
    }
    function oraclize_queryPrice(byte proofP, string datasource, uint gasLimit) oraclizeAPI internal returns (uint) {  
    	oraclize.setProofType(proofP);
    	return oraclize.getPrice(datasource, gasLimit);
    }
    function oraclize_queryPrice(byte proofP, string datasource) oraclizeAPI internal returns (uint) {  
    	oraclize.setProofType(proofP);
    	return oraclize.getPrice(datasource);
    }



    function parseAddr(string _a) internal returns (address){
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i=2; i<2+2*20; i+=2){
            iaddr *= 256;
            b1 = uint160(tmp[i]);
            b2 = uint160(tmp[i+1]);
            if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
            else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
            if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
            else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
            iaddr += (b1*16+b2);
        }
        return address(iaddr);
    }


    function strCompare(string _a, string _b) internal returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
   } 

    function indexOf(string _haystack, string _needle) internal returns (int)
    {
    	bytes memory h = bytes(_haystack);
    	bytes memory n = bytes(_needle);
    	if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
    		return -1;
    	else if(h.length > (2**128 -1))
    		return -1;									
    	else
    	{
    		uint subindex = 0;
    		for (uint i = 0; i < h.length; i ++)
    		{
    			if (h[i] == n[0])
    			{
    				subindex = 1;
    				while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
    				{
    					subindex++;
    				}	
    				if(subindex == n.length)
    					return int(i);
    			}
    		}
    		return -1;
    	}	
    }

    function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }
    
    function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(string _a, string _b, string _c) internal returns (string) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string _a, string _b) internal returns (string) {
        return strConcat(_a, _b, "", "", "");
    }

    // parseInt
    function parseInt(string _a) internal returns (uint) {
        return parseInt(_a, 0);
    }

    // parseInt(parseFloat*10^_b)
    function parseInt(string _a, uint _b) internal returns (uint) {
        bytes memory bresult = bytes(_a);
        uint mint = 0;
        bool decimals = false;
        for (uint i=0; i<bresult.length; i++){
            if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
                if (decimals){
                   if (_b == 0) break;
                    else _b--;
                }
                mint *= 10;
                mint += uint(bresult[i]) - 48;
            } else if (bresult[i] == 46) decimals = true;
        }
        return mint;
    }
    


}
// </ORACLIZE_API>

contract Rounder is usingOraclize {
    function uintCeil(uint _number, uint _roundTo) internal constant returns (uint) {
        uint _unit = findFigures(_number);
        if (_number == 0 || _unit <= _roundTo)
            return _number;
        return recursiveCeil(_number, _roundTo, _unit);
    }
    
    function uintRound(uint _number, uint _roundTo) internal constant returns (uint) {
        uint _unit = findFigures(_number);
        if (_number == 0 || _unit <= _roundTo)
            return _number;
        return recursiveRound(_number, _roundTo, _unit);
    }
    
    function uintFloor(uint _number, uint _roundTo) internal constant returns (uint) {
        uint _unit = findFigures(_number);
        if (_number == 0 || _unit <= _roundTo)
            return _number;
        return recursiveFloor(_number, _roundTo, _unit);
    }
    
    function recursiveFloor(uint _number, uint _roundTo, uint _unit) private constant returns (uint) {
        uint expUnit = power10(_unit);
        uint rounded = _number / expUnit;
        if (rounded >= 1 * power10(_roundTo))
            return rounded * expUnit;
        else
            return recursiveFloor(_number, _roundTo, _unit - 1);
    }
    
    function recursiveCeil(uint _number, uint _roundTo, uint _unit) private constant returns (uint) {
        uint expUnit = power10(_unit);
        uint rounded = _number / expUnit;
        if (rounded >= 1 * power10(_roundTo))
            return rounded * expUnit + (1 * expUnit);
        else
            return recursiveCeil(_number, _roundTo, _unit - 1);
    }
    
    function recursiveRound(uint _number, uint _roundTo, uint _unit) private constant returns (uint) {
        uint expUnit = power10(_unit);
        uint rounded = _number / expUnit;
        if (rounded >= 1 * power10(_roundTo)) {
            uint preRounded = _number / power10(_unit - 1);
            if (preRounded % 10 >= 5)
                return rounded * expUnit + (1 * expUnit);
            else
                return rounded * expUnit;
        }
        else
            return recursiveRound(_number, _roundTo, _unit - 1);
    }
    
    function findFigures(uint _number, uint _unit) private constant returns (uint) {
        if (_number / power10(_unit) < 10)
            return _unit;
        else
            return findFigures(_number, _unit + 1);
    }
    
    function findFigures(uint _number) private constant returns (uint) {
        return findFigures(_number, 1);
    }
    
    function power10(uint _number) private constant returns (uint) {
        return (10**_number) / 10;
    }
    
    function multiplyPerc(uint _number, uint _perc) internal constant returns (uint) {
        return (_number * (_perc + 100)) / 100;
    }
}

contract TimestampDatabase {
    bytes32[] public callbackStorage;
    
    function addBlockTimestamp(bytes32 _cbStorage, address _timeOwner, uint _blockTime, string _storage) external;
    function addOracleTimestamp(bytes32 _cbStorage, uint _oracleTime, string _oracleURL, bytes _proof) external;
    function getLastCallback() constant returns (bytes32);
    function getCallbackLength() constant returns (uint);
    
}

contract TimestampLogicResolver {
    function getDBAddress() constant returns (address);
}

//Timestamp code starts here
contract Timestamp is Rounder {
    
    address private creator;
    string public oracleURL;
    uint private oracleGas;
    uint private basicOraclePrice;
    uint private proofOraclePrice;
    uint8 private roundPlaces;
    uint8 private multiplier;
    bytes32 private constant wolframHash = 0x21eff6db3cf423de70b78939a0b320a09532e53b36d8e49779bb3d382f433753;
    
    struct CallbackInfo {
        address timeOwner;
        string oracleURL;
    }
    
    mapping(bytes32 => CallbackInfo) private cbInfo;
    
    //add variable before live to indicate the stamp level
    event LogBlockTimestamped(bytes32 indexed id, address timeOwner, uint blockTime, string storedValue);
    event LogOracleTimestamped(bytes32 indexed id, address timeOwner, uint oracleTime, string oracleURL, bytes proof);
    event LogCustomPriceAnnounce(uint indexed price);
    
    modifier onlyCreator () { if (msg.sender != creator) throw; _ }
    
    //ENTER RESOLVER HERE FIRST
    TimestampLogicResolver constant timestampResolver = TimestampLogicResolver(0x201bFAB09A473D4286cce0af77b04bc71b2a7aB6);
    TimestampDatabase constant timestampDB = TimestampDatabase(timestampResolver.getDBAddress());

    function Timestamp() {
        creator = msg.sender;
        oraclize_setNetwork(networkID_testnet);
        oraclize_setProof(proofType_NONE);
        oracleURL = "json(https://ntp-a1.nict.go.jp/cgi-bin/json).st";
        oracleGas = 215000; //~202k cost normally for ipfs proof, 160k for w/o ipfs proof
        roundPlaces = 2;
        multiplier = 20;
        
        (basicOraclePrice, proofOraclePrice) = getPrices();
    }
    
    function __callback(bytes32 _myid, string _result, bytes _proof) {
        if (msg.sender != oraclize_cbAddress()) throw;
        
        uint urlTime = parseInt(_result);

        //SanityCheck for custom oracle calls
        //TESTNET ONLY
        if (urlTime > now + 600 || urlTime < now - 60)
            throw;

        timestampDB.addOracleTimestamp(_myid, urlTime, cbInfo[_myid].oracleURL, _proof);
        
        LogOracleTimestamped(_myid, cbInfo[_myid].timeOwner, urlTime, cbInfo[_myid].oracleURL, _proof);
    }
    
    //Callback where no proof was requested
    function __callback(bytes32 _myid, string _result) external {
        bytes memory nil = "";
        __callback(_myid, _result, nil);
    }
    
    //TODO accept transaction if above stated + real price
    function getTime(string _data) external {
        bytes32 cbID;
        uint statedPrice;
        
        if (msg.value >= basicOraclePrice)
            statedPrice = msg.value < proofOraclePrice ? basicOraclePrice : proofOraclePrice;  
        
        uint price;
        bool pricePass;
        
        (price, pricePass) = checkOraclePrice(statedPrice);

        //initialize oracle query and retain info for callback
        if (pricePass) {
            if (price == proofOraclePrice)
                cbID = oraclize_query("URL", oracleURL, oracleGas);
            else
                cbID = oraclize_query("URL", oracleURL);
                
            cbInfo[cbID].timeOwner = msg.sender;
            cbInfo[cbID].oracleURL = oracleURL;
        }
        else {
            cbID = sha3(msg.sender, timestampDB.getLastCallback());
        }
        
        timestampToDB(cbID, _data);
        
        //ensure user gets proper refund
        //1st case is if function fallsback to blocktimestamp only, in case of insufficient 
        //ether being sent for covering the Oraclize fee
        //second case is if user sent sufficient ether of the stated price, and price indeed went higher
        //but was still sufficient to cover the oracle cost, charge client only for the stated price
        if (!pricePass)
            price = 0;
        else if (msg.value < price)
            price = statedPrice;

        refundLeftover(price);
    }
    
    function getBlockTimeOnly (string _data) external {
        bytes32 cbID;
        
        cbID = sha3(msg.sender, timestampDB.getLastCallback());
        timestampToDB(cbID, _data);
    }
    
    //can do sanity check in callback to reject invalid custom oracles
    function getTimeCustom(string _data, string _type, string _url, bool _proof) external {
        uint price;

        price = getCustomPrice(_proof, _type);
            
        bytes32 cbID = oraclize_query(_type, _url, oracleGas);
        if(isWolfram(_type)) 
            cbInfo[cbID].oracleURL = strConcat(_type, ": ", _url);
        else
            cbInfo[cbID].oracleURL = _url;
            
        cbInfo[cbID].timeOwner = msg.sender;
        
        timestampToDB(cbID, _data);
        
        refundLeftover(price);
    }
    
    function getCustomPrice(bool _proof, string _type) returns (uint) {
        byte proofType;
        
        if (_proof) 
            proofType = proofType_NONE;
        else 
            proofType = (proofType_TLSNotary | proofStorage_IPFS);
            
        uint basePrice = oraclize_queryPrice(proofType, _type, oracleGas);
        uint price = uintCeil(multiplyPerc(basePrice, multiplier), roundPlaces);
        
        LogCustomPriceAnnounce(price);

        return price;
    }
    
    function checkOraclePrice(uint _statedPrice) private returns (uint, bool) {
        uint rawBasic;
        uint rawProof;
        (rawBasic, basicOraclePrice, rawProof, proofOraclePrice) = getAllPrices();
        
        if (msg.value >= proofOraclePrice || _statedPrice >= rawProof) {
            oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
            return (proofOraclePrice, true);
        }
        else if (msg.value >= basicOraclePrice || _statedPrice >= rawBasic) {
            oraclize_setProof(proofType_NONE);
            return (basicOraclePrice, true);
        }
        else 
            return (msg.value + 1, false);
    }
    
    function getPrices() private returns (uint basicPrice, uint proofPrice) {
        uint b = oraclize_queryPrice(proofType_NONE, "URL");
        basicPrice = uintCeil(multiplyPerc(b, multiplier), roundPlaces); 
        uint p = oraclize_queryPrice(proofType_TLSNotary | proofStorage_IPFS, "URL", oracleGas);
        proofPrice = uintCeil(multiplyPerc(p, multiplier), roundPlaces);
    }
    
    function getAllPrices() private returns (uint rawBasic, uint basicPrice, uint rawProof, uint proofPrice) {
        uint b = oraclize_queryPrice(proofType_NONE, "URL");
        rawBasic = b;
        basicPrice = uintCeil(multiplyPerc(b, multiplier), roundPlaces); 
        uint p = oraclize_queryPrice(proofType_TLSNotary | proofStorage_IPFS, "URL", oracleGas);
        rawProof = p;
        proofPrice = uintCeil(multiplyPerc(p, multiplier), roundPlaces);
    }
    
    function tipCreator() external {
        if (this.balance > 0 ether)
            if (!creator.send(this.balance))
                throw;
    }
    
    //Helper functions
    function timestampToDB(bytes32 _cbID, string _data) private {
        timestampDB.addBlockTimestamp(_cbID, msg.sender, now, _data);

        LogBlockTimestamped(_cbID, msg.sender, now, _data);
    }
    
    function refundLeftover(uint _price) private {
        if (msg.value > 0) {
            if (!msg.sender.send(msg.value - _price)) 
                throw;
            if (!creator.send(this.balance))
                throw;
        }
    }
    
    function isWolfram(string x) private constant returns (bool) {
	    return sha3(x) == wolframHash ? true : false;
	}
    
    //Creator functions
    function updateOracle(string _url) onlyCreator {
        oracleURL = _url;
    }
    
    function changeRounding(uint8 _r) onlyCreator {
        roundPlaces = _r;
        (basicOraclePrice, proofOraclePrice) = getPrices();
    }
    
    function changeMultiplier(uint8 _m) onlyCreator {
        if (_m > 50) throw;
        multiplier = _m;
        (basicOraclePrice, proofOraclePrice) = getPrices();
    }
    
    //TESTNET ONLY
    function changeMultiplierNoUpdate(uint8 _m) onlyCreator {
        if (_m > 50) throw;
        multiplier = _m;
    }
    
    function updateGas(uint _g) onlyCreator {
        oracleGas = _g;
        (basicOraclePrice, proofOraclePrice) = getPrices();
    }
    
    function updateAll(string _url, uint8 _r, uint8 _m, string _c, uint _g) external onlyCreator {
        updateOracle(_url);
        changeRounding(_r);
        changeMultiplier(_m);
        updateGas(_g);
        (basicOraclePrice, proofOraclePrice) = getPrices();
    }
    
    function updateCosts(uint8 _r, uint8 _m, uint _g) external onlyCreator {
        changeRounding(_r);
        changeMultiplier(_m);
        updateGas(_g);
        (basicOraclePrice, proofOraclePrice) = getPrices();
    }
    
    //Constant functions
    function showPrices() constant returns (uint basicPrice, uint proofPrice) {
        basicPrice = basicOraclePrice;
        proofPrice = proofOraclePrice;
    }
    
    function showDatabaseAddress() constant returns (address) {
        return timestampResolver.getDBAddress();
    }
}