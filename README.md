## Teen-Konnekt App Documentation  

### Setup Instructions  

1. **Clone the Repository:**  
   ```bash
   git clone <repository-link>
   cd teen-konnekt-app
   ```

2. **Install Dependencies:**  
   Ensure you have the required dependencies installed, including Flutter and Dart.  
   ```bash
   flutter pub get
   ```

3. **Set Up Firebase (if applicable):**  
   - Add your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) files to the respective folders.  
   - Configure Firebase Authentication, Firestore, and Cloud Messaging in the Firebase Console.  

4. **Run the App:**  
   ```bash
   flutter run
   ```  
   Use a connected device or an emulator for testing.  

---

### Usage Examples  

1. **Sign Up and Login:**  
   - New users can register with their name, email, and gender.  
   - Existing users can log in with their credentials.  

2. **Access Educational Resources:**  
   - Browse curated content on Sexual and Reproductive Health and Rights (SRHR).  
   - Use the search feature to find specific topics.  

3. **Interactive Forum:**  
   - Engage in discussions with peers in moderated forums.  
   - Share experiences or ask questions anonymously.  

4. **Q&A with Experts:**  
   - Post questions privately and receive expert advice.  
   - Access previously answered questions on common SRHR topics.  

5. **Book a Session with a Counselor:**  
   - Schedule private sessions with certified counselors for tailored guidance.  

---

### Authentication Methods  

The Teen-Konnekt App implements the following authentication methods:  

1. **Email and Password Authentication:**  
   - Users can sign up or log in with their email and password.  
   - Password reset functionality is provided for users who forget their login credentials.  

2. **Social Media Authentication (Optional):**  
   - Users can sign in using their Google or Facebook accounts for convenience.  

3. **Secure Session Management:**  
   - JWT tokens are used to ensure secure session handling.  
   - User sessions are auto-logged out after a period of inactivity for enhanced security.  

---

### Security Rules Explanation  

1. **Data Encryption:**  
   - All data in transit between the app and the server is encrypted using HTTPS.  

2. **Authentication Rules:**  
   - Only authenticated users can access restricted features such as forums, Q&A, and counseling.  

3. **Role-Based Access Control (RBAC):**  
   - Users have specific roles (e.g., adolescent user, expert counselor) with tailored permissions.  
   - Experts can only access queries assigned to them, maintaining user confidentiality.  

4. **Secure Data Storage:**  
   - Sensitive data, such as session details or personal inquiries, is stored securely in Firestore with restricted access rules.  

5. **Forum Moderation:**  
   - AI and human moderators ensure that content shared in forums adheres to guidelines to protect users from harmful content or misinformation.  

6. **Backup and Recovery:**  
   - Regular backups of user data are conducted to prevent loss in case of technical issues.  
