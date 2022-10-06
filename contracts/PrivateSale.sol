//SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./Extras/Interface/IERC20.sol";
import "./Extras/access/Ownable.sol";
import "./Extras/Library/Safemath.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract preico is Ownable{
    using SafeMath for uint256;
    //start time, end time, open to all, fixed supply, available on fixed rate, soft cap, hard cap
    //no minimum buying cap,


    ///@dev For 1 wei you will be getting 2*1e12/decimalOfToken = 2*1e12/1e18 = c tokens
    //uint private rate1=4*1e12;

    ///@dev For 1 wei you will be getting 2*1e12/decimalOfToken = 2*1e12/1e18 = 0.000002 tokens
    //uint private rate2=2*1e12;

    ///@dev For 1 wei you will be getting 2*1e12/decimalOfToken = 2*1e12/1e18 = 0.000001 tokens
    // //uint private rate3=1*1e12;

    // /@dev Total 20 Million tokens are to be sold at ICO in 3 stages which  are divided into 
    // /        4 mil, 6 mil, 10 mil supply respectively


    IERC20 private token;
    //AggregatorV3Interface internal priceFeedAvax;
    //AggregatorV3Interface internal priceFeedEth;
    AggregatorV3Interface internal priceFeed;


    // uint public tokenPrice=7642621707402130 ;//USD
    // uint public currentPriceEth=130845152133;

    address payable private immutable wallet;

    struct ICOdata{
        uint rate;
        uint supply;
        uint start;
        uint end;
        uint sold;
    }

    ICOdata private ICOdatas;


    constructor (IERC20 _token, address payable _wallet) public
    {
        token = IERC20(_token);
        wallet = _wallet;
        ICOdatas=ICOdata(10,900000000000000000000000000,0,0,0);
        //priceFeedAvax = AggregatorV3Interface(0x5498BB86BC934c8D34FDA08E81D444153d0D06aD);
        //priceFeedEth=AggregatorV3Interface(0x86d67c3D38D2bCeE722E601025C25a575021c6EA);
        priceFeed = AggregatorV3Interface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);

        
    }


    function startSale() public onlyOwner{
        uint oneyear = 31536000;
            ICOdatas.start=block.timestamp;
            ICOdatas.end = ICOdatas.start +oneyear;
    }
    function _endSale() private {
        if(address(this).balance>=6250 ether){
            ICOdatas.end=block.timestamp;
        }
    }
    function endSale() public onlyOwner {
        ICOdatas.end=block.timestamp;

    }
    function LatestPriceMatic() public view returns(uint256){
        (
            /*uint80 roundID*/,
            int price_,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
         return  uint(price_);
      
    }
    
    // function getLatestPriceAvax() public view returns (uint) {
    //     (
    //         /*uint80 roundID*/,
    //         int price_,
    //         /*uint startedAt*/,
    //         /*uint timeStamp*/,
    //         /*uint80 answeredInRound*/
    //     ) = priceFeedAvax.latestRoundData();
    //     return uint(price_);
    // }
    // function getLatestPriceEth() public view returns (uint) {
    //     (
    //         /*uint80 roundID*/,
    //         int price_,
    //         /*uint startedAt*/,
    //         /*uint timeStamp*/,
    //         /*uint80 answeredInRound*/
    //     ) = priceFeedEth.latestRoundData();
    //     return uint(price_);
    // }
 

    function TokenPrice() public view returns(uint256){
        uint256 x =10**27;
       uint256 tokenPrice = x/LatestPriceMatic();
       return tokenPrice;
    }
    // function getTokenPriceAvax() public view returns(uint){
    //     uint currentPriceAvax=getLatestPriceAvax();
    //     uint currentPrice=(price.mul(10**8)).div(currentPriceAvax);
    //     return currentPrice;

    // }
    // function getTokenPriceEth() public view returns(uint){
    //     uint currentPriceEth=getLatestPriceEth();
    //     uint currentPrice=(price.mul(10**8)).div(currentPriceEth);
    //     return currentPrice;

    // }

    function allowance() public view onlyOwner returns(uint){
        return token.allowance(msg.sender, address(this));
    }

    //make sure you approve tokens to this contract address
        function buy(uint256 amount) public payable{
        require(_saleIsActive(),'Sale not active');
        uint value = _calculate(amount);
        uint _amount= amount*10**18;
        require(msg.value>=value,"Not enough Eth");
        require(ICOdatas.sold + amount<=ICOdatas.supply,'Not enough tokens, try buying lesser amount');
        token.transferFrom(wallet, msg.sender, _amount);
        ICOdatas.sold+=_amount;
        _endSale();
        
    }
    // function buyInAvax(uint256 amount) public payable{
    //     require(_saleIsActive(),'Sale not active');
    //     uint value = _calculateAvax(amount);
    //     require(msg.value==value,"Not enough avax");
    //     require(ICOdatas.sold + amount<=ICOdatas.supply,'Not enough tokens, try buying lesser amount');
    //     token.transferFrom(wallet, msg.sender, amount);
    //     ICOdatas.sold+=amount;
    //     _endSale();
        
    // }
    // function buyInEth(uint256 amount) public payable{
    //     require(_saleIsActive(),'Sale not active');
    //     uint value = _calculateEth(amount);
    //     require(msg.value==value,"Not enough Eth");
    //     require(ICOdatas.sold + amount<=ICOdatas.supply,'Not enough tokens, try buying lesser amount');
    //     token.transferFrom(wallet, msg.sender, amount);
    //     ICOdatas.sold+=amount;
    //     _endSale();
        
    // }

    function _saleIsActive() private view returns(bool){
        if(block.timestamp>=ICOdatas.end )
        {
            return false;
        }
        else if( tokensLeft()==0){return false;}
        else{return true;}
    }
    function isSaleActive() public view returns(bool){
        return _saleIsActive();
    }

 function _calculate(uint value) public view returns(uint){
        return value.mul(TokenPrice());
    }
    // function _calculateAvax(uint value) public view returns(uint){
    //     return value.mul(getLatestPriceAvax());
    // }
    
    // function _calculateEth(uint value) public view returns(uint){
    //     return value.mul(getLatestPriceEth());
    // }

    function tokensLeft() public view returns(uint){
        return ICOdatas.supply-ICOdatas.sold;
    }


    function weiRaised() public view returns(uint) {
        return address(this).balance;
    }

    function claimWei() public onlyOwner {
        wallet.transfer(address(this).balance);
    }

    // function isSuccess() public view onlyOwner returns(bool){
    //     require(!_saleIsActive(),'Sale need to end first');
    //     if(weiRaisedAmount>=softCapWei){
    //         return true;
    //     }else{return false;}
    // }

}

// 1 wei = 0.000002 tokens
// 1 ether = 1e12 tokens
// number of tokens in 'y' amount of wei => y*0.000002 tokens in real life => y*0.000002*1e18 tokens where 1e18 is the decimal of token
// example: 100 wei will get me => 0.0002 tokens => 100*2*1e18/1e6 = 2*1e14 tokens in solidity