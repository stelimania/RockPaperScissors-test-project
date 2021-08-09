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
    address winner;
    
    mapping(address => Player) public players;
    address[] gamers;
    uint moves;
    
    // Allowed withdrawals in case of Draw
    mapping(address => uint) pendingReturns;
    
    event GameStarted(uint gameid);
    event Win(address winner, address losser, uint amount, string message);
    event Draw(string message);
    
    constructor(){
        gamemaster = msg.sender;
    }
    
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
       
        // add player ( address, no move, registered, no move)
        Player memory currenPlayer = Player(msg.sender, Move.Wait, true, false);
        
        players[msg.sender] = currenPlayer;
        gamers.push(msg.sender);
        
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

    error OnlyOwner();
    modifier onlyOwner() {
        if (msg.sender != gamemaster)
            revert OnlyOwner();
        _;
    }

    function payWinner() public payable onlyOwner{
        
    }
    
    function play() public onlyOwner{
        Move player1Move = players[gamers[0]].move;
        Move player2Move = players[gamers[0]].move;
        
        if(player1Move==player2Move){
            emit Draw("It is a Draw! Try again , what will the opponent do next time ?");
        }else if(player1Move==Move.Rock){
            if(player2Move==Move.Scissors){
                winner = gamers[0];
                emit Win(gamers[0],gamers[1],0.99 ether,"Rock crushes Scissors");
            }else{
                winner = gamers[1];
                emit Win(gamers[1],gamers[0],0.99 ether,"Paper covers Rock");
            }
        }else if(player1Move==Move.Scissors){
            if(player2Move==Move.Paper){
                winner = gamers[0];
                emit Win(gamers[0],gamers[1],0.99 ether,"Scissors cuts Paper");
            }else{
                winner = gamers[1];
                emit Win(gamers[1],gamers[0],0.99 ether,"Rock crushes Scissors");
            }
        }else if(player1Move==Move.Paper){
            if(player2Move==Move.Rock){
                winner = gamers[0];
                emit Win(gamers[0],gamers[1],0.99 ether,"Paper covers Rock");
            }else{
                winner = gamers[1];
                emit Win(gamers[1],gamers[0],0.99 ether,"Scissors cuts Paper");
            }
        }
    }
    
}
