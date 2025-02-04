import React, { useState } from 'react';
import styles from './Waitlist.module.css';

export default function Waitlist() {
  const [email, setEmail] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Email submitted:", email);
    setEmail("");
  };

  return (
    <section className={styles.waitlistContainer}>
      <h2 className={styles.waitlistTitle}>Join the Waitlist</h2>
      <p className={styles.waitlistSubtitle}>
        Be the first to know when ReviZa launches. Sign up now!
      </p>
      <form className={styles.waitlistForm} onSubmit={handleSubmit}>
        <input
          type="email"
          className={styles.waitlistInput}
          placeholder="Enter your email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
        <button type="submit" className={styles.waitlistButton}>
          Join Waitlist
        </button>
      </form>
    </section>
  );
}
