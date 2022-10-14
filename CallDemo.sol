// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//Call 方法调用 其他合约

//定义一个合约部署
contract OtherContract {
    uint256 private _x = 0; // 状态变量x
    // 收到eth的事件，记录amount和gas
    event Log(uint amount, uint gas);
    
    fallback() external payable{}

    // 返回合约ETH余额
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    // 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
    function setX(uint256 x) external payable{
        _x = x;
        // 如果转入ETH，则释放Log事件
        if(msg.value > 0){
            emit Log(msg.value, gasleft());
        }
    }

    // 读取x
    function getX() external view returns(uint x){
        x = _x;
    }
}

//利用Call来调用OtherContract
contract CallDemo{
    //{call的使用规则
    // call的使用规则如下：

    // 目标合约地址.call(二进制编码);

    // 其中二进制编码利用结构化编码函数abi.encodeWithSignature获得：

    // abi.encodeWithSignature("函数签名", 逗号分隔的具体参数)

    // 函数签名为"函数名（逗号分隔的参数类型)"。例如abi.encodeWithSignature("f(uint256,address)", _x, _addr)。

    // 另外call在调用合约时可以指定交易发送的ETH数额和gas：

    // 目标合约地址.call{value:发送数额, gas:gas数额}(二进制编码);}

    // 定义Response事件，输出call返回的结果success和data

    event Response(bool success, bytes data);
    
    //调用setX函数
    function CallSetX(address payable _adress,uint256 x)public payable{
        // call setX()，同时可以发送ETH
        (bool success, bytes memory data) = _adress.call{value:msg.value}(
            abi.encodeWithSignature("setX(uint256)", x)
        );

        emit Response(success, data); //释放事件
    }
}