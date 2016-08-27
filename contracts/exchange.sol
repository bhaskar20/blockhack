contract exchange {
    address owner;
    struct TradeReq {
         uint units;
         uint price;
         uint amount;
         address addr;
        }
    struct userAccount {
         uint units;
         uint remAmt;
    }
    TradeReq[] BidReq;
    TradeReq[] AskReq;
    mapping (address=>userAccount) balance;
    
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
    function exchange() {
        owner = msg.sender;
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
                MatchCon();
            } else {
                BidReq[i].units -= AskReq[i].units;
                AskReq.length -= 1;
                //share transfer
                balance[BidReq[i].addr].units += AskReq[i].units;
                MatchCon();
            }
        }
    }

    function bid(uint units, uint price) {
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

    function ask(uint units, uint price) checkBalance(units) {
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
}