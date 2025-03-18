// List of random names for the bot
const botNames = ["Alex", "Sam", "Jordan", "Charlie", "Taylor", "Morgan", "Jamie", "Casey"];

// Pick a random bot name when the page loads
const botName = botNames[Math.floor(Math.random() * botNames.length)];

document.addEventListener("DOMContentLoaded", function () {
    let chatBox = document.getElementById("chat-box");

    // Set the first message dynamically with a random bot name
    chatBox.innerHTML = `<div class="bot-message"><b>${botName}:</b> Hello! How can I help you today?</div>`;

    let sendButton = document.querySelector("button");
    sendButton.addEventListener("click", sendMessage);

    // Allow pressing Enter to send messages
    document.getElementById("user-input").addEventListener("keypress", function (event) {
        if (event.key === "Enter") {
            sendMessage();
        }
    });
});

function sendMessage() {
    let userInput = document.getElementById("user-input").value.trim();
    let chatBox = document.getElementById("chat-box");
    let sendButton = document.querySelector("button");

    if (userInput === "") return;

    sendButton.disabled = true; // Prevent multiple clicks

    // Append user message
    chatBox.innerHTML += `<div class="user-message"><b>You:</b> ${userInput}</div>`;

    fetch("http://127.0.0.1:8000/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ message: userInput })
    })
    .then(response => response.json())
    .then(data => {
        let botMessage = data.reply.replace(/\n/g, "<br>"); // Convert \n to <br> for UI

        // Append bot response
        chatBox.innerHTML += `<div class="bot-message"><b>${botName}:</b> ${botMessage}</div>`;

        chatBox.scrollTop = chatBox.scrollHeight; // Auto-scroll to the latest message
        document.getElementById("user-input").value = ""; // Clear input
    })
    .catch(error => {
        console.error("Error:", error);
        chatBox.innerHTML += `<div class="bot-message error"><b>${botName}:</b> Oops! Something went wrong. Try again later.</div>`;
    })
    .finally(() => {
        sendButton.disabled = false;
    });
}
    