contract TimestampLogicResolver {

    address public creator;
    address private logicAddr;
    address private DBAddr;
    
    modifier onlyCreator() { if (msg.sender != creator) throw; _ }
    
    event LogUpdatedLogic(address indexed logic, address creator);
    
    function TimestampLogicResolver() {
        creator = msg.sender;
    }
    
    function lockUpdates() onlyCreator external {
        creator = address(0);
    }
    
    //Testnet only, will be removed
    function unlockUpdates() external {
        if (creator != address(0))
            throw;
            
        creator = 0x8C19c1F5c6EC53361B770994B1F4b99f52132665;
    }
    
    function setDBAddress(address _DBAddr) onlyCreator external {
        if (DBAddr != address(0)) throw;
        
        DBAddr = _DBAddr;
    }
    
    function setLogicAddress(address _logicAddr) onlyCreator external {
        logicAddr = _logicAddr;
        
        LogUpdatedLogic(_logicAddr, creator);
    }

    function getLogicAddress() external constant returns (address) {
        return logicAddr;
    }
    
    function getDBAddress() external constant returns (address) {
        return DBAddr;
    }
}