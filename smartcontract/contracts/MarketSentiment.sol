// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract MarketSentiment{

    address public owner;
    string[] public tickersArray;

    constructor(){
        owner = msg.sender;
    }

    struct ticker{
        bool exists;
        uint256 up;
        uint256 down;
        mapping(address=>bool) Voters;
    }

    event tickerupdated(
        uint256 up,
        uint256 down,
        address voter,
        string ticker
    );

    mapping(string => ticker) private Tickers;

    function addTicker(string memory _ticker) public {
        require(msg.sender == owner, "Only the owner can create tickers"); //only owner of smart contract can add new tickers

        ticker storage newTicker = Tickers[_ticker];
        newTicker.exists = true;
        tickersArray.push(_ticker);
    }

    function vote(string memory _ticker, bool _vote) public{
        require(Tickers[_ticker].exists,"Can't vote on this coin"); //checking ticker is available for voting or not
        require(!Tickers[_ticker].Voters[msg.sender],"You have already voted"); //already voted address wont able to vote again

        ticker storage t = Tickers[_ticker];
        t.Voters[msg.sender] = true;

        if(_vote){
            t.up++;
        }else{
            t.down++;
        }

        //emitting the updated event for the moralis to get 
        emit tickerupdated(t.up, t.down, msg.sender, _ticker);
    }

    function getVotes(string memory _ticker) public view returns(
        uint256 up,
        uint256 down
    ){
        require(Tickers[_ticker].exists, "No such Ticker Defined");
        ticker storage t = Tickers[_ticker];
        return(t.up,t.down);
        
    }
}