// SPDX-License-Identifier: Unlicense

import "./crowdsale.sol";

pragma solidity ^0.8.9;

abstract contract CappedCrowdsale is Crowdsale {
    uint256 private _cap;

    constructor(uint256 cap_) {
        require(cap_ > 0, "CappedCrowdsale: cap cannot be zero");
        _cap = cap_;
    }

    function cap() public view returns (uint256) {
        return _cap;
    }

    function capReached() public view returns(bool) {
        return weiRaised() >= _cap;
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal virtual override {
        super._preValidatePurchase(beneficiary, weiAmount);
        require((weiRaised() + weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
    }
}

