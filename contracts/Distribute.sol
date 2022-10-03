// SPDX-License-Identifier: Unlicense

pragma solidity 0.6.12;

import "./token.sol";
import "./Extras/Interface/IERC20.sol";
import "./Extras/Interface/Vesting.sol";
import './Vesting/vest.sol';
import './Extras/utils/context.sol';

contract Distribute is Context {

    address private admin;
    IERC20 token;

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
    address public Treasury=0x784aD26F3dff4B164979F36724d8E0297dc2581e;
  
   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
       modifier onlyOwner() {
        require(admin == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    // Token Time lock

    address public foundersTimelock=0x895aadbe123Fc95C95010cDCB5431aD9F09Baa70;
    address public PublicTimelock=0x2381C4F2026C4D7C12EE5090658E7aFB9bA5f6A8;
    address public MarketingTimelock=0x788eafA52d6CC7Aab5dE55398A5f7B5778b99C7D;
    address public AdvisorTimelock=0x694DAb2e697e3ed65143347D73483B970c64433e;
    address public EcoSystemTimelock=0xF72663305dF976bA8c1b44Ceab69B7946d1B696B;

    bool private _finalized;
    event CrowdsaleFinalized();

  

    constructor(
        address payable _wallet,
        IERC20 _token
    )  public
  
    {
       
        _finalized = false;
        admin = msg.sender;
        Private=_wallet;
        Public=_wallet;
        token=_token;
      
        
    }

   

    function finalized() public view returns(bool) {
        return _finalized;
    }


    function finalize() public {
        require(msg.sender == admin, "No access to call function");
        require(!_finalized, "FinalizedCrowdsale: already finalized");
        //require(hasClosed(), "FinalizableCrowdsale: crowdsale has not closed");

       IERC20 funtoken=token;
        uint256 decimalfactor = 1e18;

        funtoken.mint(foundersTimelock, (founderCommunityToken * decimalfactor) );
        funtoken.mint(PublicTimelock,PublicToken * decimalfactor);
        funtoken.mint(Private,PrivateToken * decimalfactor);
        funtoken.mint(MarketingTimelock,MarketingToken * decimalfactor);
        funtoken.mint(AdvisorTimelock,AdvisorToken * decimalfactor);
        funtoken.mint(EcoSystemTimelock,EcoSystemToken * decimalfactor);
        funtoken.mint(Treasury,TreasuryToken * decimalfactor);
        _finalized = true;

        _finalization();
        emit CrowdsaleFinalized();
    }

    function _finalization() internal {} 

    function AddVesting( address _benefiary,uint _startTime, uint256 _releaseTime, uint256 _amount) public {
        IVest Vest = IVest(_benefiary);
        Vest.addVesting((_startTime), _releaseTime, _amount);
    }
    function release( address _benefiary, uint256 vesting_id) public {
        IVest Vest = IVest(_benefiary);
        Vest.release(vesting_id);
    }
     
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(admin, newOwner);
        admin = newOwner;
    }
}