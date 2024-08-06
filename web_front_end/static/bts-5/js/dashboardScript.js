/* file: dashboardScript.js */

// Import Firebase SDKs and configure Firebase (similar to testfile.html)
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getAuth, signOut } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-auth.js";

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyB-HOo4dN79-d0Z1e3sWwuF-UGvlSmhcMc",
    authDomain: "testfile-1aec5.firebaseapp.com",
    projectId: "testfile-1aec5",
    storageBucket: "testfile-1aec5.appspot.com",
    messagingSenderId: "103563495546",
    appId: "1:103563495546:web:382b619c7e501f1e6053c3"
};

// Initialize Firebase (similar to testfile.html)
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

const signOutButton = document.querySelector("#signOutButton");

const userSignOut = async () => {
    await signOut(auth)
        .then(() => {
            // Redirect back to the login page after signing out
            alert("You are now signed out!");
            window.location.href = "/";
        })
        .catch((error) => {
            const errorCode = error.code;
            const errorMessage = error.message;
            console.log(errorCode, errorMessage);
        });
}

signOutButton.addEventListener("click", userSignOut);