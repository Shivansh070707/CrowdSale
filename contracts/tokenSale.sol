// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "./token.sol";
import "./capcrowdsale.sol";
import "./timedcrowdsale.sol";
import "./crowdsale.sol";
import "./Extras/tokentimelock.sol";

contract Crowd_Token is Crowdsale, CappedCrowdsale, TimedCrowdsale {
    // Track Contributions
    uint256 public minInvestorPrice = 2 wei;
    uint256 public maxInvestorPrice = 50 wei;
    mapping(address => uint256) public contributions;

    // Crowdsale Stages
    enum CrowdsaleStage { PreICO, ICO }
    CrowdsaleStage public stage = CrowdsaleStage.PreICO;

    address private admin;

    // Token Distribution
    uint256 public ICOToken=2500000000;
    uint256 public MarketingToken=1700000000;
    uint256 public founderCommunityToken=1000000000;
    uint256 public AdvisorToken=500000000;
    uint256 public ReservesToken=1500000000;
    uint256 public StakingToken=1000000000;
    uint256 public futuresToken=500000000;

    // Token reserve funds
    address ICO=0x03D2434Ef06Ca621aeB961F399cFEAE1A2134D7F;
    address public Marketing=0x8005Bd2698fD7dd63B92132530D961915fbD1B4C;
    address public founderCommunity=0x718148ff5E44254ac51a9D2D544fdd168c1a85D4;
    address public Advisor=0x6C763a8E16266c05e796f5798C88FF1305c4878d;
    address public Reserves=0x02E839EF8a2e3812eCcf7ad6119f48aB2560228a;
    address public Staking=0xfE30c9B5495EfD5fC81D8969483acfE6Efe08d61;
    address public futures=0x6203F881127C9F4f1DdE0e7de9C23c8C9289c34D;

    // Token Time lock
    uint256 public releaseTime;
    address public foundersTimelock;


    bool private _finalized;
    event CrowdsaleFinalized();


    constructor(
        uint256 _rate,
        address payable _wallet,
        Token _token,
        uint256 _cap,
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _releaseTime
    ) 
        Crowdsale(_rate, _wallet, _token)
        CappedCrowdsale(_cap)
        TimedCrowdsale(_openingTime, _closingTime)
    {
        releaseTime = _releaseTime;
        _finalized = false;
        admin = msg.sender;
        
    }

    function getUserContributions(address _beneficiary) public view returns (uint256) {
        return contributions[_beneficiary];
    }

    function getCrowdsaleStage() public view returns (CrowdsaleStage _stage){
        return stage;
    }

    function setCrowdsaleStage(uint _stage) public {
        require(msg.sender == admin, "TokenSale: No access to call function");
        if(uint(CrowdsaleStage.PreICO) == _stage) {
            stage = CrowdsaleStage.PreICO;
        } else if (uint(CrowdsaleStage.ICO) == _stage) {
            stage = CrowdsaleStage.ICO;
        }

        // if(stage == CrowdsaleStage.PreICO) {
        //     _rate = 500;
        // } else if(stage == CrowdsaleStage.ICO) {
        //     _rate = 250;
        // }
    }

    function _forwardFunds() internal override {
        if(stage == CrowdsaleStage.PreICO) {
            _wallet.transfer(msg.value);
        } else if(stage == CrowdsaleStage.ICO) {
            super._forwardFunds();
        }
    }

    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal override(Crowdsale, CappedCrowdsale, TimedCrowdsale) {
        super._preValidatePurchase(_beneficiary, _weiAmount);
        uint256 _existingContribution = contributions[_beneficiary];
        uint256 _newContribution = _existingContribution + _weiAmount;
        require(_newContribution >= minInvestorPrice && _newContribution <= maxInvestorPrice, "TokenSale: Investor price is not up to minimum or has exceeded maximum");
        contributions[_beneficiary] = _newContribution;
    }

     function finalized() public view returns(bool) {
        return _finalized;
    }

    function finalize() public {
        require(msg.sender == admin, "No access to call function");
        require(!_finalized, "FinalizedCrowdsale: already finalized");
        require(hasClosed(), "FinalizableCrowdsale: crowdsale has not closed");

       Token funtoken;

   //_token = funtoken;
       // uint256 alreadyMinted = funtoken.totalSupply();
        uint256 decimalfactor = 1e18;

        //uint256 _finalTokenSupply = (alreadyMinted / tokenSalePercentage) * 100;

        TokenTimelock _foundersTimelock = new TokenTimelock(funtoken, founderCommunity, releaseTime);

        foundersTimelock = address(_foundersTimelock);


        funtoken.mint(foundersTimelock, (founderCommunityToken * decimalfactor) );
        funtoken.mint(ICO,ICOToken * decimalfactor);
        funtoken.mint(Marketing,MarketingToken * decimalfactor);
        funtoken.mint(Advisor,AdvisorToken * decimalfactor);
        funtoken.mint(Reserves,ReservesToken * decimalfactor);
        funtoken.mint(Staking,StakingToken * decimalfactor);
        funtoken.mint(futures,futuresToken * decimalfactor);

        _finalized = true;

        _finalization();
        emit CrowdsaleFinalized();
    }

    function _finalization() internal {} 

} 