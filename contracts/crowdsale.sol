// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./Token.sol";
import "./Extras/Interface/IERC20.sol";
import "./Extras/reentrancy.sol";
import "./Extras/utils/context.sol";
import "./Extras/Interface/IERC20.sol";




abstract contract Crowdsale is Context, ReentrancyGuard {
    IERC20 internal _token;
    address payable internal _wallet;
    uint256 internal _rate;
    uint256 private _weiRaised;

    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    constructor(uint256 rate_, address payable wallet_, IERC20 token_) public {
        require(rate_ > 0, "Crowdsale: rate cannot be 0");
        require(wallet_ != address(0), "Crowdsale: wallet cannot be zero address");
        require(address(token_) != address(0), "Crowdsale: token address cannot be zero address");

        _rate = rate_;
        _wallet = wallet_;
        _token = IERC20(token_);
    }

    function token() public view returns (address) {
        return address(_token);
    }

    function wallet() public view returns (address payable) {
        return _wallet;
    }

    function rate() public view returns(uint256) {
        return _rate;
    }

    function weiRaised() public view returns(uint256) {
        return _weiRaised;
    }

    function _getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
        return weiAmount * _rate;
    }

    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        _token.transfer(beneficiary, tokenAmount);
    }

    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
        _deliverTokens(beneficiary, tokenAmount);
    }

    function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {}

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal virtual {
        require(beneficiary != address(0), "Crowdsale: beneficiary cannot be zero address");
        require(weiAmount != 0, "Crowdsale: wei amount cannot be 0");
        this;
    }

    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal {}

    function _forwardFunds() internal virtual {
        _wallet.transfer(msg.value);
    }

    function buyTokens(address beneficiary) public nonReentrant payable {
        uint256 weiAmount = msg.value;
        _preValidatePurchase(beneficiary, weiAmount);

        uint256 tokens = _getTokenAmount(weiAmount);

        _weiRaised += weiAmount;

        _processPurchase(beneficiary, tokens);
        emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);

        _updatePurchasingState(beneficiary, weiAmount);

        _forwardFunds();
        _postValidatePurchase(beneficiary, weiAmount);

    }

    fallback() external payable {
        buyTokens(_msgSender());
    }

    receive() external payable {
        buyTokens(_msgSender());
    }
}