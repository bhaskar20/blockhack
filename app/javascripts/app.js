var accounts;
var account;

function setStatus(message) {
  var status = document.getElementById("status");
  status.innerHTML = message;
};

function refreshBalance() {
  var ex = exchange.deployed();
  ex.currentPrice().then(function (value) {
    console.log(value.valueOf());
  });
  ex.getBalance.call(account).then(function(value) {
    var balance_element = document.getElementById("balance");
    balance_element.innerHTML = value.valueOf();
  }).catch(function(e) {
    console.log(e);
    setStatus("Error getting balance; see log.");
  });
  ex.getCurrentPrice.call(account).then(function(value) {
    var curP = document.getElementById("curPrice");
    curP.innerHTML = value.valueOf();
  }).catch(function(e) {
    console.log(e);
    setStatus("Error getting balance; see log.");
  });
};

function getUnits() {
  var ex = exchange.deployed();
  ex.getunits.call(account,{from: account}).then(function (value) {
    refreshBalance();
  })
}

// function sendBid() {
//   var bidAmt = document.getElementById("asknum").value;
//   var bidUnits = document.getElementById("askunit").value
//   ex.bid.call(account,bidAmt,bidUnits,).then(function(value)
// }

window.onload = function() {
  web3.eth.getAccounts(function(err, accs) {
    if (err != null) {
      alert("There was an error fetching your accounts.");
      return;
    }

    if (accs.length == 0) {
      alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
      return;
    }

    accounts = accs;
    account = accounts[0];
    console.log(account);
    console.log(accounts);

    refreshBalance();
  });
}
