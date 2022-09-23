//SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./Extras/Interface/IERC20.sol";
import "./Extras/access/Ownable.sol";
contract preico is Ownable{
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
        ICOdatas=ICOdata(144, 900000000 ,0,0,0);
    }


    function startSale() public onlyOwner{
        uint oneyear = 31536000;
            ICOdatas.start=block.timestamp;
            ICOdatas.end = ICOdatas.start +oneyear;
    }

    function allowance() public view onlyOwner returns(uint){
        return token.allowance(msg.sender, address(this));
    }

    //make sure you approve tokens to this contract address
    function buy() public payable{
        require(_saleIsActive(),'Sale not active');
        uint amount = _calculate(msg.value);
        require(ICOdatas.sold + amount<=ICOdatas.supply,'Not enough tokens, try buying lesser amount');
        token.transferFrom(wallet, msg.sender, amount);
        ICOdatas.sold+=amount;
        
    }

    function _saleIsActive() private view returns(bool){
        if(block.timestamp>=ICOdatas.end && 
            tokensLeft()==0)
        {
            return false;
        }
        else{return true;}
    }


    function _calculate(uint value) public view returns(uint){
        return value*ICOdatas.rate;
    }

    function tokensLeft() public view returns(uint){
        return ICOdatas.supply-ICOdatas.sold;
    }


    function weiRaised() public view returns(uint) {
        return ICOdatas.sold/ICOdatas.rate;
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