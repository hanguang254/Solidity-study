// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract test{
    uint256  public index ;


    function test11() external {
        
        for(uint i = 0 ;i<=index;i++){
            index = index-1;
        }

    }

    function test22() external{
        uint c = index;
        for(uint i = 0 ;i<20;i++){
            c = c+1;
        }
        index = c;

    }
}