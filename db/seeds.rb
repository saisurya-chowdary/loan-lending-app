admin_user = AdminUser.find_or_initialize_by(email: 'admin@example.com') do |admin|
    admin.password = 'password'
    admin.password_confirmation = 'password'
end
admin_user.save! if Rails.env.development?
Wallet.create!(balance: 10_00_000, admin_user: admin_user)