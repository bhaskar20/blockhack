contract exchange {
    address owner;
    struct TradeReq {
         uint units;
         uint price;
         uint amount;
         address addr;
        }
    struct userAccount {
         bytes32 poi;
         uint units;
         uint remAmt;
    }
    TradeReq[] public BidReq;
    TradeReq[] public AskReq;
    uint public currentPrice;
    mapping (address=>userAccount) balance;
    mapping (address=>bool) user;
    
    //events
    event TradeSuccess(address _from, address _to, uint price);

    modifier checkBalance(uint units) {
        if(balance[msg.sender].units < units){
            throw;
        }
        _
    }
    modifier onlyAdmin() {
        if (msg.sender != owner) {
            throw;
        }
        _
    }
    modifier onlyCorrectUser() {
        if(user[msg.sender] != true ) {
            throw;
        }
        _
    }
    function exchange() {
        owner = msg.sender;
        currentPrice = 10;
    }

    function MatchCon() {
        //match tradereq and ask req array
        uint i=AskReq.length-1;
        uint j=BidReq.length-1;
        if(AskReq[i].price <= BidReq[j].price){
            if(AskReq[i].units >= BidReq[i].units){
                AskReq[i].units -= BidReq[i].units;
                BidReq.length -=1;
                //share transfer
                balance[BidReq[i].addr].units += BidReq[i].units;
                currentPrice = BidReq[i].price;
                MatchCon();
            } else {
                BidReq[i].units -= AskReq[i].units;
                AskReq.length -= 1;
                //share transfer
                balance[BidReq[i].addr].units += AskReq[i].units;
                currentPrice = BidReq[i].price;
                MatchCon();
            }
        }
    }

    function bid(uint units, uint price) onlyCorrectUser {
        if ( msg.value >= units*price) throw;
        var bidTrade = TradeReq(units,price,msg.value,msg.sender);

        // insert in sorted bidreq
        uint i = BidReq.length - 1;
        while (price < BidReq[i].price && i>=0){
            BidReq[i+1] = BidReq[i];
            i--;
        }
        BidReq[i+1] = bidTrade;

        MatchCon();
    }

    function ask(uint units, uint price) checkBalance(units) onlyCorrectUser {
        var askTrade = TradeReq(units,price,0,msg.sender);
        
        //stop double spending
        balance[msg.sender].units -= units;
        // insert in sorted askreq
        uint i = AskReq.length - 1;
        while (price > AskReq[i].price && i>=0){
            AskReq[i+1] = AskReq[i];
            i--;
        }
        AskReq[i+1] = askTrade;

        MatchCon();
    }

    function giveUnits(address _to,uint units) onlyAdmin {
        balance[_to].units = units;
    }

    function withdraw() {
        
    }

    // function getActiveTrades() returns (){
    //     return (BidReq,AskReq);
    // }
    function getCurrentPrice() returns (uint) {
        return currentPrice;
    }
    function getBalance() returns (uint){
        if (user[msg.sender] != true) return 0;
        else {
            return balance[msg.sender].units;
        }
    }
    function getunits() returns (bool){
        if(user[msg.sender] != true){
            user[msg.sender] = true;
        }
        balance[msg.sender] = userAccount(10,2000);
        return true;
    }

}