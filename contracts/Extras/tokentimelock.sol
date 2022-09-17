// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import "../token.sol";

contract TokenTimelock {
    Token internal _token;
    address private immutable _beneficiary;
    uint256 private immutable _releaseTime;

    constructor(Token token_, address beneficiary_, uint256 releaseTime_) {
        require(releaseTime_ > block.timestamp, "TokenTimelock: release time cannot happen before current time");
        _token = token_;
        _beneficiary = beneficiary_;
        _releaseTime = releaseTime_;
    }


    function token() public view virtual returns (Token) {
        return _token;
    }

    function beneficiary() public view virtual returns (address) {
        return _beneficiary;
    }

    function releaseTime() public view virtual returns (uint256) {
        return _releaseTime;
    }

    function release() public virtual {
        require(block.timestamp >= releaseTime(), "TokenTimelock: current time cannot be before release time");

        uint256 amount = token().balanceOf(address(this));
        require(amount > 0, "TokenTimelock: there are no tokens to release");

        token().transfer(beneficiary(), amount);
    }
}