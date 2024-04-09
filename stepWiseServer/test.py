from werkzeug.security import check_password_hash, generate_password_hash
password = "password12345"
print(generate_password_hash(password))

print(check_password_hash(password=password, pwhash="scrypt:32768:8:1$Vtd2SBAMPJoIqydh