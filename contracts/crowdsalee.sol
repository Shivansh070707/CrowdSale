// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "./token.sol";
import "./capcrowdsale.sol";
import "./timedcrowdsale.sol";
import "./crowdsale.sol";
import "./Extras/tokentimelock.sol";
import './Extras/vesting.sol';

contract Crowd_Token is Crowdsale, CappedCrowdsale, TimedCrowdsale {
  
    mapping(address => uint256) public contributions;

    address private admin;

    // Token Distribution
    uint256 public PrivateToken=900000000;
    uint256 public PublicToken=2500000000;
    uint256 public MarketingToken=1700000000;
    uint256 public founderCommunityToken=1000000000;
    uint256 public AdvisorToken=300000000;
    uint256 public EcoSystemToken=1100000000;
    uint256 public TreasuryToken=2500000000;

    // Token reserve funds
    address public Private;
    address public Marketing=0x8005Bd2698fD7dd63B92132530D961915fbD1B4C;
    address public founderCommunity=0x718148ff5E44254ac51a9D2D544fdd168c1a85D4;
    address public Advisor=0x6C763a8E16266c05e796f5798C88FF1305c4878d;
    address public EcoSystem=0x02E839EF8a2e3812eCcf7ad6119f48aB2560228a;
    address public Treasury=0xfE30c9B5495EfD5fC81D8969483acfE6Efe08d61;
  

    // Token Time lock
    uint256 public releaseTime;
    address public foundersTimelock;
    address public PublicTimelock;
    address public PrivateTimelock;
    address public MarketingTimelock;
    address public AdvisorTimelock;
    address public EcoSystemTimelock;
    

    bool private _finalized;
    event CrowdsaleFinalized();


    constructor(
        uint256 _rate,
        address payable _wallet,
        Token _token,
        uint256 _cap,
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _releaseTime,
        address preico
      
    ) 
        Crowdsale(_rate, _wallet, _token)
        CappedCrowdsale(_cap)
        TimedCrowdsale(_openingTime, _closingTime)
    {
        releaseTime = _releaseTime;
        _finalized = false;
        admin = msg.sender;
        Private=preico;
      
        
    }

    function getUserContributions(address _beneficiary) public view returns (uint256) {
        return contributions[_beneficiary];
    }

  

    // function setCrowdsaleStage(uint _stage) public {
    //     require(msg.sender == admin, "TokenSale: No access to call function");
    //     if(uint(CrowdsaleStage.PreICO) == _stage) {
    //         stage = CrowdsaleStage.PreICO;
    //     } else if (uint(CrowdsaleStage.ICO) == _stage) {
    //         stage = CrowdsaleStage.ICO;
    //     }

    //     // if(stage == CrowdsaleStage.PreICO) {
    //     //     _rate = 500;
    //     // } else if(stage == CrowdsaleStage.ICO) {
    //     //     _rate = 250;
    //     // }
    // }

    function _forwardFunds() internal override {
 
            _wallet.transfer(msg.value);
        
    }

    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal override(Crowdsale, CappedCrowdsale, TimedCrowdsale) {
        super._preValidatePurchase(_beneficiary, _weiAmount);
        uint256 _existingContribution = contributions[_beneficiary];
        uint256 _newContribution = _existingContribution + _weiAmount;
        // require(_newContribution >= minInvestorPrice && _newContribution <= maxInvestorPrice, "TokenSale: Investor price is not up to minimum or has exceeded maximum");
        contributions[_beneficiary] = _newContribution;
    }

     function finalized() public view returns(bool) {
        return _finalized;
    }


    function finalize() public {
        require(msg.sender == admin, "No access to call function");
        require(!_finalized, "FinalizedCrowdsale: already finalized");
        //require(hasClosed(), "FinalizableCrowdsale: crowdsale has not closed");

       Token funtoken=_token;
      
       // uint256 alreadyMinted = funtoken.totalSupply();
        uint256 decimalfactor = 1e18;

        //uint256 _finalTokenSupply = (alreadyMinted / tokenSalePercentage) * 100;

        // TokenTimelock _foundersTimelock = new TokenTimelock(funtoken, founderCommunity, releaseTime);
        Vesting Vest = new Vesting(_token);
    
      
        // Vesting _foundersTimelock = new Vesting(_token,founderCommunity,3,[1726759983,1758295983,1789831983],[400000000,300000000,300000000]);
        // Vesting _AdvisorTimelock = new Vesting(_token,Advisor,3,[1695137583,1726759983,1758295983],[100000000,100000000,100000000]);
        // // Vesting _MarketingTimelock = new Vesting(_token,Marketing,5,[1695137583,1726759983,1758295983,1789831983,1821367983],[500000000,300000000,300000000,300000000,300000000]);
        // Vesting _PublicTimelock = new Vesting(_token,_wallet,5,[1695137583,1726759983,1758295983,1789831983,1821367983],[500000000,500000000,500000000,500000000,500000000]);
        // Vesting _EcoSystemTimelock = new Vesting(_token,EcoSystem,3,[1758295983,1789831983,1821367983],[400000000,400000000,300000000]);
    
       

        // foundersTimelock = address(_foundersTimelock);
        // PublicTimelock=address(_PublicTimelock);
        // //PrivateTimelock=address(_PrivateTimelock);
        // //MarketingTimelock=address(_MarketingTimelock);
        // AdvisorTimelock=address(_AdvisorTimelock);
        // EcoSystemTimelock=address(_EcoSystemTimelock);


        funtoken.mint(founderCommunity, (founderCommunityToken * decimalfactor) );
        funtoken.mint(_wallet,PublicToken * decimalfactor);
        funtoken.mint(Private,PrivateToken * decimalfactor);
        funtoken.mint(Marketing,MarketingToken * decimalfactor);
        funtoken.mint(Advisor,AdvisorToken * decimalfactor);
        funtoken.mint(EcoSystem,EcoSystemToken * decimalfactor);
        funtoken.mint(Treasury,TreasuryToken * decimalfactor);
        Vest.grant(founderCommunity,400000000,1726759983,1789831983,1789838983,false);
    

        _finalized = true;

        _finalization();
        emit CrowdsaleFinalized();
    }

    function _finalization() internal {} 

}