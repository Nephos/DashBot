module DashBot::Plugins::Anarchism
  extend self
  @@is_op = false
  @@user_list = Array(Crirc::Protocol::User).new

  def bind(bot)
    bind_new_user bot
    bind_on_op bot
  end

  def bind_new_user(bot)
    bot.on("JOIN") do |msg, _|
      if @@is_op
        chan = Crirc::Protocol::Chan.new msg.message.to_s
        user = Crirc::Protocol::User.new msg.source.source_nick
        bot.mode chan, "+o", user
      end
    end
  end

  def bind_on_op(bot)
    bot.on("MODE") do |msg, _|
      if msg.arguments.to_s.match(/\#.* \+o #{bot.network.nick}\z/)
        chan = Crirc::Protocol::Chan.new msg.arguments.to_s.split(" ")[0]
        @@is_op = true
        @@user_list = Array(Crirc::Protocol::User).new
        bot.names(chan)
      elsif msg.arguments.to_s.match(/\#.* \-o #{bot.network.nick}\z/)
        @@is_op = false
      end
    end

    bot.on("353") do |msg, _|
      msg.message.to_s.split(" ").each do |nick|
        @@user_list.push Crirc::Protocol::User.new nick.lstrip("@+")
      end
    end

    bot.on("366") do |msg, _|
      if @@is_op
        @@user_list.each do |user|
          chan = Crirc::Protocol::Chan.new "#ratonade"
          bot.mode chan, "+o", user
        end
      end
    end
  end
end
