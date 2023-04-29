// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleEscrow {
    address payable public buyer;
    address payable public seller;
    uint256 public amount;
    bool public buyerReceivedItem;

    // Event that is emitted when funds are deposited into the escrow
    event FundsDeposited(address buyer, uint256 amount);

    // Event that is emitted when funds are released to the seller
    event FundsReleased(address seller, uint256 amount);

    // Constructor to initialize the buyer, seller, and amount
    constructor(address payable _seller, uint256 _amount) {
        buyer = payable(msg.sender);
        seller = _seller;
        amount = _amount;
        buyerReceivedItem = false;
    }

    // Function for the buyer to deposit funds into the escrow
    function depositFunds() public payable {
        require(msg.sender == buyer, "Only the buyer can deposit funds.");
        require(msg.value == amount, "Incorrect deposit amount.");
        emit FundsDeposited(buyer, msg.value);
    }

    // Function for the buyer to confirm receipt of the item and release funds to the seller
    function confirmReceipt() public {
        require(msg.sender == buyer, "Only the buyer can confirm receipt.");
        require(address(this).balance == amount, "Insufficient funds in escrow.");
        buyerReceivedItem = true;
        seller.transfer(amount);
        emit FundsReleased(seller, amount);
    }

    // Function to check the balance of the escrow contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
