contract mainExchange {
    address owner;
    struct TradeReq {
        "type": uint, // 0 for ask 1 for bid
        "units" : uint,
        "price" : uint,
        "
        }
    
    TradeReq[] BidReq;
    TradeReq[] AskReq;
    mapping (address=>trade) trades;
    mapping (address=>uint) balance;
    
    function mainExchange() {

    }

    function bid(uint units, uint price) {
        var bidTrade = TradeReq({"type":1,"units":units,"price":price});

        if (askReq[0].price < ..){

            //check if all units completed
            // else push in bid req, after sorting
            // also decrease the balance of bidder
        } else {
            // 
        }
        // logic to check if the trade is matching

        // save the trade
    }

    function ask(type name) {
        var askTrade = TradeReq({"type":1,"units":units,"price":price});
    }
}