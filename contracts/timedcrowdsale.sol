// SPDX-License-Identifier: Unlicense

import "./crowdsale.sol";

pragma solidity ^0.8.9;

abstract contract TimedCrowdsale is Crowdsale {
    uint256 private _openingTime;
    uint256 private _closingTime;

    event TimeExtended(uint256 prevClosingTime, uint256 newClosingTime);

    modifier onlyWhileOpen {
        require(isOpen(), "TimedCrowdsale: Crowdsale not open");
        _;
    }

    constructor (uint256 openingTime, uint256 closingTime) {
        require(openingTime >= block.timestamp, "TimedCrowsale: Opening time cannot be before current time");
        require(closingTime > openingTime, "TimedCrowdsale: Closing time cannot be before opening Time");

        _openingTime = openingTime;
        _closingTime = closingTime;
    }

    function isOpen() public view returns(bool) {
        return block.timestamp >= _openingTime && block.timestamp < _closingTime;
    }

    function hasClosed() public view returns(bool) {
        return block.timestamp > _closingTime;
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen virtual override {
        super._preValidatePurchase(beneficiary, weiAmount);
    }

    function _extendTime(uint256 newClosingTime) internal {
        require(!hasClosed(), "TimedCrowdsale: Crowdsale already closed");
        require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time has to be ahead of current closing time");

        emit TimeExtended(_closingTime, newClosingTime);
        _closingTime = newClosingTime;
    }
}