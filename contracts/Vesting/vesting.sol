// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
import "../Extras/Library/Safemath.sol";
import "../Extras/Interface/IERC20.sol";
import "../Extras/access/Ownable.sol";


contract Vesting is Ownable {

  // beneficiary of tokens after they are released

    using SafeMath for uint256;


    event TokensReleased(address token, uint256 amount);
    event TokenVestingRevoked(address token);

    // beneficiary of tokens after they are released
    address private _beneficiary;

    // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
    uint256 private _cliff;
    uint256 private _start;
    uint256 private _duration;

    bool private _revocable;
    IERC20 token;

    mapping (address => uint256) private _released;
    mapping (address => bool) private _revoked;

   
    constructor (IERC20 _token,address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, bool revocable) public {
        require(beneficiary != address(0), "TokenVesting: beneficiary is the zero address");
        // solhint-disable-next-line max-line-length
        require(cliffDuration <= duration, "TokenVesting: cliff is longer than duration");
        require(duration > 0, "TokenVesting: duration is 0");
        // solhint-disable-next-line max-line-length
        require(start.add(duration) > block.timestamp, "TokenVesting: final time is before current time");
         token=IERC20(_token);
        _beneficiary = beneficiary;
        _revocable = revocable;
        _duration = duration;
        _cliff = start.add(cliffDuration);
        _start = start;
    }

    function beneficiary() public view returns (address) {
        return _beneficiary;
    }

    function cliff() public view returns (uint256) {
        return _cliff;
    }

 
    function start() public view returns (uint256) {
        return _start;
    }

    function duration() public view returns (uint256) {
        return _duration;
    }

  
    function revocable() public view returns (bool) {
        return _revocable;
    }

  
    function released() public view returns (uint256) {
        return _released[address(token)];
    }

 
    function revoked() public view returns (bool) {
        return _revoked[address(token)];
    }

  
    function release() public {
        uint256 unreleased = _releasableAmount();

        require(unreleased > 0, "TokenVesting: no tokens are due");

        _released[address(token)] = _released[address(token)].add(unreleased);

        token.transfer(_beneficiary, unreleased);

        emit TokensReleased(address(token), unreleased);
    }

   
    function revoke() public onlyOwner {
        require(_revocable, "TokenVesting: cannot revoke");
        require(!_revoked[address(token)], "TokenVesting: token already revoked");

        uint256 balance = token.balanceOf(address(this));

        uint256 unreleased = _releasableAmount();
        uint256 refund = balance.sub(unreleased);

        _revoked[address(token)] = true;

        token.transfer(owner(), refund);

        emit TokenVestingRevoked(address(token));
    }

   
    function _releasableAmount() private view returns (uint256) {
        return _vestedAmount().sub(_released[address(token)]);
    }

  
    function _vestedAmount() private view returns (uint256) {
        uint256 currentBalance = token.balanceOf(address(this));
        uint256 totalBalance = currentBalance.add(_released[address(token)]);

        if (block.timestamp < _cliff) {
            return 0;
        } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {
            return totalBalance;
        } else {
            return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
        }
    }
}