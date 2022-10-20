// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract test{
    uint[] public ab;


    function testpush(uint256 amount) external{
        ab.push(amount);
        
    }

    function testpop() external{
        ab.pop();
    
    }
    


}

