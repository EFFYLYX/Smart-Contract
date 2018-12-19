pragma solidity ^0.4.17;

// contract Adoption {
//     address[16] public adopters;//16 pets to be adopted
//     //store the address of adopter related to correponding pet number

//     function adopt(uint petID) public returns (uint ) {
//         require(petID >= 0 && petID <= 15);
//         adopters[petID] = msg.sender;
//     }

//     function getAdopters() public view returns (address[16]){
//         return adopters;
//     }

// }

contract Adoption{
    //parameter
    address public supplier;
    uint public auction_end;
    uint public energy_for_trade;

    address public highest_bidder;
    uint public highest_bid;

    //可以取回的之前的报价
    mapping(address => uint) Ret;

    bool end;

    event Update_highest_bid(address bidder, uint new_price);
    event Auction_ended(address winner, uint price);

    constructor(
        uint bidding_time,
        address _supplier,
        uint _energy_for_trade
    ) public payable {
        supplier = _supplier;
        auction_end=now + bidding_time;
        energy_for_trade = _energy_for_trade;
    }

    function bid() public payable{
        require(now <= auction_end, "Auction is closed.");
        require(msg.value > highest_bid, "There exists a higher price.");
        
        if(highest_bid != 0){
            Ret[highest_bidder] = Ret[highest_bidder] + highest_bid;
        }
        highest_bidder = msg.sender;
        highest_bid = msg.value;
        emit Update_highest_bid(msg.sender, msg.value);
    }

    function return_deposit() public payable returns (bool success){
        uint return_money = Ret[msg.sender];
        if (return_money > 0){
            Ret[msg.sender] = 0;

            if (!msg.sender.send(return_money)){
                Ret[msg.sender] = return_money;
                return success = false;
            }
        }
        return success = true;
    }

    function auction_End() public payable{
        require (now >= auction_end);
        require(!end, "auction has been closed");

        end = true;
        emit Auction_ended(highest_bidder, highest_bid);

        supplier.transfer(highest_bid);
    }
}