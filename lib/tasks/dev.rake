namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") do
      %x(rails db:drop)
      end 
      
      show_spinner("Criando BD...") do
      %x(rails db:create)
      end
        # Com "do e end", Ou desse modo entre chaves

      show_spinner("Migrando DB...") {%x(rails db:migrate)}

      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
                  
    else 
      puts "Você não está em ambiente de denvolvimento!"
    end
  end

  desc "Cadastra as moedas"
    task add_coins: :environment do
      show_spinner("Cadastrando moedas...") do
        coins = [
          { description: "Bitcoin",
          acronym: "BTC",
          url_image: "http://pngimg.com/uploads/bitcoin/bitcoin_PNG47.png",
          mining_type: MiningType.find_by(acronym: "PoW")
          },

          { description: "Ethereum",
          acronym: "ETH",
          url_image: "https://cdn2.iconfinder.com/data/icons/cryptocurrency-5/100/cryptocurrency_blockchain_crypto-02-512.png",
          mining_type: MiningType.all.sample
          },

          { description: "Dash",
          acronym: "DASH",
          url_image: "https://www.newsbtc.com/wp-content/uploads/2017/12/dash-logo.png",
          mining_type: MiningType.all.sample
          },

          { description: "Iota",
          acronym: "IOT",
          url_image: "https://satoshiwatch.com/wp-content/uploads/2017/09/Silver-IOTA.jpg",
          mining_type: MiningType.all.sample
          },

          { description: "ZCash",
          acronym: "ZEC",
          url_image: "https://cdn4.iconfinder.com/data/icons/zcash-bitcoin-crytocurrency/128/zcash_crypto_cryptocurrency_coin_coins-03-512.png",
          mining_type: MiningType.all.sample
          }
        ]
      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

    desc "Cadastro dos Tipos de Mineração"
      task add_mining_types: :environment do
        show_spinner("Cadastrando tipos de mineração...") do
        mining_types = [
          {description: "Proof of Work", acronym: "PoW"},
          {description: "Proof of Stake", acronym: "PoS"},
          {description: "Proof of Capacity", acronym: "PoC"}
        ]
        mining_types.each do |mining_type|
          MiningType.find_or_create_by!(mining_type)
        end
      end
    end

  private

  def show_spinner(msg_start, msg_end = "Concluído com sucesso")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
      spinner.auto_spin
      yield
      spinner.success("(#{msg_end})")
  end
end
