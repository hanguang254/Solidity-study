// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "transferFactory/transferActive.sol";


contract transferFactory{
    address[] public  transferCotract;


    function CreateTransfer() external {
        // 创建子合约
        TranActive newContract =new TranActive();
        newContract.transferOwnership(msg.sender);
        transferCotract.push(address(newContract));
    }

    function getDeployedContracts() public view returns (address[] memory) {
        return transferCotract;
    }

}