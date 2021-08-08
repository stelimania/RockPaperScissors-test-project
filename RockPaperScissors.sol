// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * demo interview class
 */
 
contract RockPaperScissors{
    
    // Possible moves for players
    enum Move { Wait, Rock, Paper, Scissors }
    
    struct Player {
        address id;
        Move move;  // unique move
        bool registered;
        bool moved;
    }

    address public gamemaster;
    mapping(address => Player) public players;
    Player[] gamers;
    uint moves;
    
    // Allowed withdrawals in case of Draw
    mapping(address => uint) pendingReturns;
    
    
    modifier condition(bool _condition) {
        require(_condition);
        _;
    }
    
    event GameStarted(uint gameid);
    event Win(address winner, address losser, uint amount, string message);
    event Draw();
    
    function registerToPlay(address player2)  public payable {
       
        require(
            gamers.length<2, 
            "2 players already entered the game."   
        );
        
        require(
            msg.sender != player2,
            "Cannot play against yourself."
        );
        
        require(
            msg.value == 1 ether,
            "Bet must be 1 ether"
        );
        
        //players[msg.sender] = Player(Move.Wait, true, false);
        gamers.push(Player(msg.sender, Move.Wait, true, false));
        
    }

    function bet(Move move) public payable{
        //check 2 players move;
        require(
            moves<2,
            "Players already moved."
        );
        
        require(
            !(players[msg.sender].moved),
            "You already moved."
        );
        
        players[msg.sender].move = move;
        players[msg.sender].moved = true;
        moves++;
        
    }

    function play() public payable {
        Move player1Move = gamers[0].move;
        Move player2Move = gamers[1].move;
        
        if(player1Move==player2Move){
            emit Draw();
        }else if(player1Move==Move.Rock){
            if(player2Move==Move.Scissors){
                emit Win(gamers[0].id,gamers[1].id,0.99 ether,"Rock crushes Scissors");
            }else{
                emit Win(gamers[1].id,gamers[0].id,0.99 ether,"Paper covers Rock");
            }
        }else if(player1Move==Move.Scissors){
            if(player2Move==Move.Paper){
                emit Win(gamers[0].id,gamers[1].id,0.99 ether,"Scissors cuts Paper");
            }else{
                emit Win(gamers[1].id,gamers[0].id,0.99 ether,"Rock crushes Scissors");
            }
        }else if(player1Move==Move.Paper){
            if(player2Move==Move.Rock){
                emit Win(gamers[0].id,gamers[1].id,0.99 ether,"Paper covers Rock");
            }else{
                emit Win(gamers[1].id,gamers[0].id,0.99 ether,"Scissors cuts Paper");
            }
        }
    }
    
}
