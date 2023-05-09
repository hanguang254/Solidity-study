// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (utils/Context.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";


contract SaleWallet is Ownable{
    event Received(address, uint);
    event PublicSaleETHEvent(address, uint256);

    mapping (uint => address) public SaleAddress;
    mapping (address => uint) public SaleShare;
    uint256 public  BlanceValue ;
    uint private  participant;
    bool private _locked;
    uint256 public supply = 120000000000000000000;


    receive() external payable {
        require(msg.value <= remaining() ,"The pre-sale quota cannot be greater than the remaining quota");
        PublicSaleETH();
        emit Received(msg.sender, msg.value);
    }
    

    function PublicSaleETH() payable public returns (bool) {
        require(msg.value > 80000000000000000, "Invalid amount");  
        uint256 sold = remaining();
        
        if(sold > 0){

            participant++; // increase the number of participants
            uint index = participant;
            SaleAddress[index] = msg.sender;
            SaleShare[msg.sender] = msg.value / 80000000000000000;
            BlanceValue += msg.value; // Add the received ETH to the balance of the smart contract account
            
            emit PublicSaleETHEvent(msg.sender, msg.value);
            
        }else if (sold == 0) {
            payable(msg.sender).transfer(msg.value);
        }
        return true;
    }


    function getParticipantIndex() public view returns(uint) {
        return participant;
    }

    function remaining() public  view returns (uint256) {
        uint256 remain  = supply - BlanceValue;
        return remain;
    }

    function withdraw(uint256 amount) external  onlyOwner {
        require(amount <= address(this).balance, "Insufficient contract balance");
        require(!_locked, "Withdraw already in progress");
        _locked = true;
        uint256 withdrawalAmount = amount;
        _locked = false;
        (bool success,) = msg.sender.call{value: withdrawalAmount}("");
        require(success, "Withdraw failed");
    }
    
    
}