// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "./tokenInterface.sol";
import "../utils/pausable.sol";
import "./safemath.sol";
import '../utils/Ownable.sol';


contract Vesting is Ownable, Pausable {

    using SafeMath for uint256;
  

    struct Release {
        uint256 timestamp;
        uint256 amount;
        bool released;
    }

    Release[] public _releases;

    // IERC20 basic token contract being held
    IERC20  public Token_;

    // beneficiary of tokens after they are released
    address  public beneficiary;
    


  constructor(IERC20 token_, address beneficiary_, uint32[] memory releaseTimestamps_, uint32[] memory releaseAmounts_) {

        require(releaseTimestamps_.length == releaseAmounts_.length, "TokenTimeLock: Invalid release schedule");

        Token_ = token_;
        beneficiary = beneficiary_;

        for (uint256 i = 0; i < releaseTimestamps_.length; i++) {
            _releases.push(Release(releaseTimestamps_[i], releaseAmounts_[i], false));
        }

    }

    /**
     * @return the token being held.
     */
    function Token() external view virtual returns (IERC20) {
        return Token_;
    }

    /**
     * @return the beneficiary of the tokens.
     */
    function Beneficiary() external view virtual returns (address) {
        return beneficiary;
    }

    /**
     * @return the time when the tokens are released.
     */
    function getReleaseAmount() external view virtual returns (uint256) {

        uint256 releaseAmount = 0;

        for (uint256 i = 0; i < _releases.length; i++) {
            Release memory r = _releases[i];

            if(!r.released && block.timestamp >= r.timestamp)
                releaseAmount = releaseAmount.add(r.amount);
        }

        return releaseAmount;
    }

    /**
     * @notice Transfers tokens held by timeLock to beneficiary.
     */
    function release() external virtual onlyOwner whenNotPaused {

        require(Token_.balanceOf(address(this)) > 0, "TokenTimeLock: no tokens held by contract");

        uint256 releaseAmount = 0;

        for (uint256 i = 0; i < _releases.length; i++) {
            Release storage r = _releases[i];

            if(!r.released && block.timestamp >= r.timestamp && releaseAmount < Token_.balanceOf(address(this)) ){
                  releaseAmount = releaseAmount.add(r.amount);
                  r.released = true;

            }
        }


        require(releaseAmount > 0, "TokenTimeLock: no tokens to release");

        if(releaseAmount > Token_.balanceOf(address(this)))
            releaseAmount = Token_.balanceOf(address(this));

        Token_.transfer(beneficiary, releaseAmount);
    }

    /// Withdraw any IERC20 tokens accumulated in this contract
    function withdrawTokens(IERC20 _token2) external onlyOwner whenNotPaused {
        _token2.transfer(owner(), _token2.balanceOf(address(this)));
    }

    function getOwner() external view returns (address) {
        return owner();
    }

    //
    // IMPLEMENT PAUSABLE FUNCTIONS
    //
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}