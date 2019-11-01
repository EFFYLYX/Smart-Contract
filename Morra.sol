pragma solidity >=0.4.22 <0.6.0;
contract Morra{

    address public owner;
    address public winner;
    // uint256 myNumber;
    // uint256 myGuess;

    struct Player{
        address payable myAddress;
        uint256 myNumber;
        uint256 hisNumber;

    }


    Player[] players;


    constructor () public{
        owner = msg.sender;

    }
    function getPlayerNumber()public view returns (uint){
        return players.length;
    }
    function checkPlayerExists(address playerAddress) public view returns (bool){
        for(uint256 i = 0; i < players.length;i++){
            if(players[i].myAddress == playerAddress){
                return true;
            }
        }

        return false;
    }
    function applyPick(address payable sender,uint256 myNumber,uint256 hisNumber) internal{

        players.push(Player(sender,myNumber,hisNumber));

    }



    function pick(uint256 myNumber) payable public{
        require(!checkPlayerExists(msg.sender));
        require(players.length <2);
        require(msg.value ==1 ether || msg.value == 2 ether || msg.value == 3 ether || msg.value == 4 ether|| msg.value ==5 ether);
        require(myNumber >=1 && myNumber <=5);
        uint256 hisNumber = msg.value / (10**18);
        applyPick(msg.sender,myNumber,hisNumber);


        if(getPlayerNumber()== 2){

            showHand();
        }


    }
    function showHand() private{
        require(players.length ==2);

        uint256 reward = (players[0].hisNumber + players[1].hisNumber)*(10**18);

        if(players[0].hisNumber == players[1].myNumber && players[1].hisNumber != players[0].myNumber){
            players[0].myAddress.transfer(reward);
            winner = players[0].myAddress;

        }else{
            if(players[1].hisNumber == players[0].myNumber && players[0].hisNumber != players[1].myNumber){
            players[1].myAddress.transfer(reward);
            winner = players[1].myAddress;

        }else{
            players[0].myAddress.transfer(players[0].hisNumber * (10**18));
            players[1].myAddress.transfer(players[1].hisNumber * (10**18));

        }
        }


        delete players;


    }

    function withdraw() external{

    }



}
