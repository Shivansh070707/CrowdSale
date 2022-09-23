// SPDX-License-Identifier: Unlicense

pragma solidity 0.6.12;

import "./token.sol";
import "./Extras/Interface/IERC20.sol";
import "./Extras/Interface/Vesting.sol";
import "./crowdsale.sol";
import './Vesting/vest.sol';

contract Distribute is Crowdsale {
  
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
    address public Public;
    address public Marketing=0x8005Bd2698fD7dd63B92132530D961915fbD1B4C;
    address public founderCommunity=0x718148ff5E44254ac51a9D2D544fdd168c1a85D4;
    address public Advisor=0x6C763a8E16266c05e796f5798C88FF1305c4878d;
    address public EcoSystem=0x02E839EF8a2e3812eCcf7ad6119f48aB2560228a;
    address public Treasury=0xfE30c9B5495EfD5fC81D8969483acfE6Efe08d61;
  

    // Token Time lock

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
        IERC20 _token
       
      
    ) 
        Crowdsale(_rate, _wallet, _token) public
  
    {
       
        _finalized = false;
        admin = msg.sender;
        Private=_wallet;
        Public=_wallet;
      
        
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

    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal override(Crowdsale) {
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

       IERC20 funtoken=_token;
      
       // uint256 alreadyMinted = funtoken.totalSupply();
        uint256 decimalfactor = 1e18;

        //uint256 _finalTokenSupply = (alreadyMinted / tokenSalePercentage) * 100;

        // TokenTimelock _foundersTimelock = new TokenTimelock(funtoken, founderCommunity, releaseTime);
        // Vesting Vest = new Vesting(_token);
    
      
        Vesting _foundersTimelock = new Vesting(_token,founderCommunity);
        Vesting _AdvisorTimelock = new Vesting(_token,Advisor);
        Vesting _MarketingTimelock = new Vesting(_token,Marketing);
        Vesting _PublicTimelock = new Vesting(_token,_wallet);
        Vesting _EcoSystemTimelock = new Vesting(_token,EcoSystem);
    
       

        foundersTimelock = address(_foundersTimelock);
        PublicTimelock=address(_PublicTimelock);
        //PrivateTimelock=address(_PrivateTimelock);
        MarketingTimelock=address(_MarketingTimelock);
        AdvisorTimelock=address(_AdvisorTimelock);
        EcoSystemTimelock=address(_EcoSystemTimelock);


        funtoken.mint(foundersTimelock, (founderCommunityToken * decimalfactor) );
        funtoken.mint(PublicTimelock,PublicToken * decimalfactor);
        funtoken.mint(Private,PrivateToken * decimalfactor);
        funtoken.mint(MarketingTimelock,MarketingToken * decimalfactor);
        funtoken.mint(AdvisorTimelock,AdvisorToken * decimalfactor);
        funtoken.mint(EcoSystemTimelock,EcoSystemToken * decimalfactor);
        funtoken.mint(Treasury,TreasuryToken * decimalfactor);
        _foundersTimelock.addVesting(64646,6666464,646);
        _PublicTimelock.addVesting(1663926794, 1663926907,250);
        // Vest.grant(founderCommunity,400000000,1726759983,1789831983,1789838983,false);
    

        _finalized = true;

        _finalization();
        emit CrowdsaleFinalized();
    }

    function _finalization() internal {} 
    function release( address _benefiary, uint256 vesting_id) public {
        IVest Vest = IVest(_benefiary);
        Vest.release(vesting_id);
    }

}