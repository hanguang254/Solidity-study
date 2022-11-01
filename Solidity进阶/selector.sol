// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
   
contract test{
    // event 返回msg.data
    event Log(bytes data);
    event Transfer(address sender,address recipient,uint amount);
    mapping(address => uint) balanceOf;

    function mint(address to) external{
        emit Log(msg.data);
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
}

    