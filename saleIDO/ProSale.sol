
// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    // function renounceOwnership() public virtual onlyOwner {
    //     _transferOwnership(address(0));
    // }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: PreSale.sol


pragma solidity ^0.8.0;


//预售合约
//记录预售地址，预售数量定一个初始价格，
contract PreSale is Ownable,ReentrancyGuard{
     struct preSaleMess {
        bool isLeg; //是否合法
        uint256 money; //预售份额
     }
     event TransEvent(address,uint);
    //每份预售的金额
    uint256 private preSaleAmout;
    //白名单地址
    address[] whitelist;
    //预售信息
    mapping(address => preSaleMess) preSaleMessByAddress;
    constructor(uint256 _amount){
        whitelist = new address[](0);
        preSaleAmout = _amount;
    }
    //预售白名单
    //_number: 预售份数
    function SaleByEth(uint256 _number) public payable nonReentrant {
        require(msg.value >= getPreSaleAmout()*_number,"transfer amount must be positive");
        require(msg.sender.balance >= getPreSaleAmout()*_number,"Must have sufficient amount");
        require(preSaleMessByAddress[msg.sender].isLeg||preSaleMessByAddress[msg.sender].money==0&&preSaleMessByAddress[msg.sender].isLeg==false,"Illegal status");
        //preSaleMessByAddress.hasKey(msg.sender);
        //存储预售信息
        if (preSaleMessByAddress[msg.sender].money==0&&preSaleMessByAddress[msg.sender].isLeg==false){
             //将地址添加至白名单
             _addWhitelist(msg.sender);
        }
        preSaleMessByAddress[msg.sender].money+=getPreSaleAmout()*_number;
        (bool callSuccess, ) = payable(address(this)).call{value: msg.value}("");
        require(callSuccess, "transfer to contract failed");
        emit TransEvent(msg.sender,msg.value);
    }
    //获得地址存款金额
    function getDeposit(address _addr) public  view  returns (uint256) {
        return preSaleMessByAddress[_addr].money;
    }
   //提取合约金额
    function withdraw(uint256 _amount) public onlyOwner  {
        (bool callSuccess, ) = payable(msg.sender).call{value: _amount}("");
        require(callSuccess, "withdraw failed");
         emit TransEvent(address(this),_amount);
    }
    //查询每份预售的金额
    function getPreSaleAmout() public view  returns (uint256) {
        return preSaleAmout;
    }
    //设置新的预售金额
    function setPreSaleAmout(uint256 _amount) onlyOwner public {
        preSaleAmout = _amount;
    }
    //添加地址至白名单
    function _addWhitelist(address _addr) private {
        //判断地址是否存在
        whitelist.push(_addr);
    }
    //获得合约余额
    function getBalanceForContract() public view returns(uint256) {
        return address(this).balance;
    }
    //获得白名单信息
    function getWhitelist() public view  returns (address[] memory) {
        return whitelist;
    }
    fallback() external payable {}

    receive() external payable {}
}