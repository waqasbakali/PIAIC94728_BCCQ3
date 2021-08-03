// SPDX-License-Identifier: MIT 
pragma solidity 0.8.4;

// Create Crypto Bank Contract
// 1) The owner can start the bank with initial deposit/capital in ether (min 50 eths)
// 2) Only the owner can close the bank. Upon closing the balance should return to the Owner
// 3) Anyone can open an account in the bank for Account opening they need to deposit ether with address
// 4) Bank will maintain balances of accounts
// 5) Anyone can deposit in the bank
// 6) Only valid account holders can withdraw
// 7) First 5 accounts will get a bonus of 1 ether in bonus
// 8) Account holder can inquiry balance
// 9) The depositor can request for closing an account


// Create Crypto Bank Contract
contract MyCryptoBank{

    address owner = msg.sender;
    uint initialCapital;
    uint8 AccountNo;
    
    mapping (address => bool) accountsList; //Maintains list of accounts opened
    mapping (address => bool) accountsStatus; //Maintains account open/close status

// 4 ---- Bank maintains account balances
    mapping (address => uint) accBalances; //Maintains account balance

// 1 ---- Owner starts a bank with 50 ethers
    constructor() payable{
        require (msg.value >= 50 ether, "My Crypto Bank now has balance of:");
        initialCapital = msg.value;
        accBalances[msg.sender] = msg.value; //Transfer balance into accountBalances
    }
    
// 2 ---- Only owner can close the bank, owner gets all the balance of teh contract
    modifier onlyOwner(){
        require (msg.sender == owner, "Only the bank owner can close the bank.");
        _;
    }
    
    function _5_closeBank() public onlyOwner payable{
        address payable addr = payable(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4));
        selfdestruct(addr);
    }

    
// 3 & 7 ---- Anyone can open an account and first 5 accounts gets bonus of 1 ether
    function _1_openNewAcc() payable public returns(string memory, uint8){
        require(msg.value > 0 ether && msg.sender != address(0), "You must transfer some ethers.");
        require(accountsList[msg.sender] != true, "Account already exist"); 
        accountsList[msg.sender] = true;
        accountsStatus[msg.sender] = true;
        AccountNo ++;
        if(AccountNo <= 5){
            accBalances[msg.sender] = msg.value + 1 ether; //Transfer opening amount and bonus into first 5 accounts.
        }
        
        else{accBalances[msg.sender] = msg.value;} //Transfer opening amount after 6th account.);
            
        accBalances[address(this)] += msg.value; //Bank balance to increase by deposit amount.
        return("A new account is opened.", AccountNo);
    }
    
    
// 5 ---- Anyone can deposit in the bank
    function _2_depositEther() public payable{
        require(msg.sender != address(0));
        
        if(accountsList[msg.sender] = true){
            accBalances[address(this)] += msg.value; //Bank balance to increase by deposit amount.
        }
    }
    

// 6 ---- Withdrawal by valid accountholders, values only in ethers
    function _3_acc_Wdraw(uint _ether) public payable {
        _ether = _ether*10**18;
        require(accountsList[msg.sender] != false, "You don't have an account with us.");
        require(accountsStatus[msg.sender] != false, "Your account is closed.");
        require(_ether <= accBalances[msg.sender], "You have insufficient Ethers.");
        
        payable(msg.sender).transfer(_ether);
        accBalances[msg.sender] -= _ether;
    }
    
// 9 ---- The depositor can request for closing an account
    function _4_AccClosingRequest() public returns(string memory, bool){
        require(accountsList[msg.sender] != false, "You don't have an account with us.");
        require(accountsStatus[msg.sender] != false, "Your account is closed.");
        payable(msg.sender).transfer(accBalances[msg.sender]);
        accountsStatus[msg.sender] = false;
        return("Your account is closed", accountsStatus[msg.sender]);
    }
    
  
    
    
    
        
///View functions
    //Checks contract balance
    function _1_chkConBal() public view returns(uint, string memory){
        return (address(this).balance,"The contract now has ethers.");
    }
    
    //Checks total accounts opened
    function _2_TotalAcc() public view returns (uint8){
        return(AccountNo);
    }
    
// 8 ---- Account holder can inquiry balance
    function _3_chkAccBal() public view returns (uint accountBalance){
        require(accountsStatus[msg.sender] != false, "Your account is closed."); 
        return(accBalances[msg.sender]);
    }
    
    //Checks accounts opening status
    function _4_isOpened() public view returns (bool status){
        return(accountsList[msg.sender]);
    }
    
    //Checks account active status
    function _5_isActive() public view returns (bool status){
        return(accountsStatus[msg.sender]);
    }
    
}
