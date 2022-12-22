// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Fund_Transfer {
    address payable sender;
    uint amount;
    uint [] t;
    uint final_amount;
    uint f;
    constructor() payable{
        sender = payable(msg.sender);
        amount = msg.value;
        final_amount = 0;
        f=0;
    }
    function _transfer(address payable r) internal {
        require(sender.balance >= amount, "Not enough balance");
        r.transfer(amount);
    }

    function _final_calculator(uint _rate, uint _time) internal{
        final_amount = final_amount + (amount * _rate * _time)/100;
    }

    function _loan_repayment(address payable r) internal{
        require(r.balance >= final_amount , "Not Enough Balance");
        sender.transfer(final_amount);
        
    }


    function penalty_tracker(address payable receiver, uint r1, uint t1, bool ch1, bool ch2, bool ch3) external{
        /*ch1 asks if user wants to call the _transfer function, 
        ch2 asks if user wants to call _final_calculator function 
        ch3 asks if user wants to call the _loan_repayment function*/
        r1 = r1/100;
        /* The user is instructed to enter rate * 100 as solidity cannot handle float values,
        and time is input in days */
        t.push(uint256(block.timestamp / 24 / 60 / 60)) ;
        uint i = 0;
        while (true){
            if (uint256(block.timestamp / 24 / 60 / 60) > uint256(t[0]+ t1) + i * 365){
                break;
            }
            r1 = r1 + 1;
            i = i + 1;
        }
    

        /*Rate is increased by 1 once when time limit is passed 
        and increased by 1 furthermore every time a year has passed */

        if (ch1 == true){
            _transfer(receiver);
        }
        if (f==0){
            if (ch2 == true){
                 _final_calculator(r1, t1);
                 if (ch3 == true){
                     _loan_repayment(receiver);
                 }
            }
        }

    }
}

