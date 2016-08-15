contract TimestampLogicResolver {
    function getLogicAddress() constant returns (address);
}

contract TimestampDatabase {

    struct TimestampStorage {
        address timeOwner;
        uint blockTime;
        uint oracleTime;
        string oracleURL;
        string storedValue;
        bytes proof;
    }
    
    mapping(bytes32 => TimestampStorage) private timestampStorage;
    
    bytes32 [] public callbackStorage;
    
    address private creator;
    
    modifier onlyTimestampLogic() { if (msg.sender != timestampLogic.getLogicAddress()) throw; _ }
    
    //Enter Resolver address here
    TimestampLogicResolver constant timestampLogic = TimestampLogicResolver(0x201bFAB09A473D4286cce0af77b04bc71b2a7aB6);

    function addBlockTimestamp(bytes32 _cbStorage, address _timeOwner, uint _blockTime, string _storage) onlyTimestampLogic external {
        if (timestampStorage[_cbStorage].timeOwner != 0) 
            throw;
            
        callbackStorage.push(_cbStorage);
        
        timestampStorage[_cbStorage].blockTime = now;
        timestampStorage[_cbStorage].storedValue = _storage;
        timestampStorage[_cbStorage].timeOwner = _timeOwner;
    }
    
    function addOracleTimestamp(bytes32 _cbStorage, uint _oracleTime, string _oracleURL, bytes _proof) onlyTimestampLogic external {
        if (timestampStorage[_cbStorage].oracleTime != 0) 
            throw;
            
        timestampStorage[_cbStorage].proof = _proof;
        timestampStorage[_cbStorage].oracleURL = _oracleURL;
        timestampStorage[_cbStorage].oracleTime = _oracleTime;
    }
    
    function getLastCallback() constant returns (bytes32) {
        return callbackStorage[callbackStorage.length - 1];
    }
    
    function getCallbackLength() constant returns (uint) {
        return callbackStorage.length;
    }
    
    function showTimestamps(uint _i) constant returns (address timestampOwner,
    uint blockTime,
    uint oracleTime,
    string oracleURL,
    bytes proof,
    string storedValue) {
        bytes32 tID = callbackStorage[_i];
        timestampOwner = timestampStorage[tID].timeOwner;
        blockTime = timestampStorage[tID].blockTime;
        oracleTime = timestampStorage[tID].oracleTime;
        oracleURL = timestampStorage[tID].oracleURL;
        proof = timestampStorage[tID].proof;
        storedValue = timestampStorage[tID].storedValue;
    }
}