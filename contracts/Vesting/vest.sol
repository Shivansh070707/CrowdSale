// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
import "../Extras/Library/Safemath.sol";
import "../Extras/Interface/IERC20.sol";



contract Vesting  {
    using SafeMath for uint256;
  

    IERC20 private Token;
    uint256 public tokensToVest = 0;
    uint256 private vestingId = 0;
    address internal Beneficiary;
    address owner;

    string private constant INSUFFICIENT_BALANCE = "Insufficient balance";
    string private constant INVALID_VESTING_ID = "Invalid vesting id";
    string private constant VESTING_ALREADY_RELEASED = "Vesting already released";
    string private constant INVALID_BENEFICIARY = "Invalid beneficiary address";
    string private constant NOT_VESTED = "Tokens have not vested yet";

    struct Vesting_ {
        uint256 startTime;
        uint256 releaseTime;
        uint256 amount;
        address beneficiary;
        bool released;
    }
    mapping(uint256 => Vesting_) public vestings;

    event TokenVestingReleased(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
    event TokenVestingAdded(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);
    event TokenVestingRemoved(uint256 indexed vestingId, address indexed beneficiary, uint256 amount);

    modifier onlyOwner(){
        require(msg.sender==owner,"Only owner can run this");
        _;
    }

    constructor(IERC20 _token,address _beneficiary) public {
        require(address(_token) != address(0x0), "Matic token address is not valid");
        Token = _token;
        Beneficiary=_beneficiary;
        owner=Beneficiary;
    }

    function token() public view returns (IERC20) {
        return Token;
    }

    function beneficiary(uint256 _vestingId) public view returns (address) {
        return vestings[_vestingId].beneficiary;
    }
 
    function releaseTime(uint256 _vestingId) public view returns (uint256){
        return vestings[_vestingId].releaseTime;
    }

    function vestingAmount(uint256 _vestingId) public view returns (uint256) {
        return vestings[_vestingId].amount;
    }

    function removeVesting(uint256 _vestingId) public onlyOwner {
        Vesting_ storage vesting = vestings[_vestingId];
        require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);
        require(!vesting.released , VESTING_ALREADY_RELEASED);
        vesting.released = true;
        tokensToVest = tokensToVest.sub(vesting.amount);
        emit TokenVestingRemoved(_vestingId, vesting.beneficiary, vesting.amount);
    }

    function addVesting(uint _startTime, uint256 _releaseTime, uint256 _amount) public  {
        require(Beneficiary != address(0x0), INVALID_BENEFICIARY);
        require(Token.balanceOf(address(this))>=_amount+tokensToVest);
        tokensToVest = tokensToVest.add(_amount);
        vestingId = vestingId.add(1);
        vestings[vestingId] = Vesting_({
            startTime:_startTime,
            beneficiary: Beneficiary,
            releaseTime: _releaseTime,
            amount: _amount,
            released: false
        });
        emit TokenVestingAdded(vestingId,Beneficiary, _amount);
    }

    function release(uint256 _vestingId) public {
        Vesting_ storage vesting = vestings[_vestingId];
        require(vesting.beneficiary != address(0x0), INVALID_VESTING_ID);
        require(!vesting.released , VESTING_ALREADY_RELEASED);
        // solhint-disable-next-line not-rely-on-time
        require(block.timestamp >= vesting.releaseTime, NOT_VESTED);

        require(Token.balanceOf(address(this)) >= vesting.amount, INSUFFICIENT_BALANCE);
        vesting.released = true;
        tokensToVest = tokensToVest.sub(vesting.amount);
        Token.transfer(vesting.beneficiary, vesting.amount);
        emit TokenVestingReleased(_vestingId, vesting.beneficiary, vesting.amount);
    }

    function retrieveExcessTokens(uint256 _amount) public onlyOwner {
        require(_amount <= Token.balanceOf(address(this)).sub(tokensToVest), INSUFFICIENT_BALANCE);
        Token.transfer(owner, _amount);
    }
}