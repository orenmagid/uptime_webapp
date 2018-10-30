class Possibility < ApplicationRecord
  has_many :activities
  has_many :users, through: :activities

  #----calculates user statistics and average rating
  def user_possibility_stats(user_id)

    self.average_rating = Activity.where(possibility_id: self.id, user_id: user_id).average("rating")

    accepted = Activity.where(possibility_id: self.id, user_id: user_id, status: "accepted").count + Activity.where(possibility_id: self.id, user_id: user_id, status: "accepted and completed").count + Activity.where(possibility_id: self.id, user_id: user_id, status: "accepted but not completed").count

    rejected = Activity.where(possibility_id: self.id, user_id: user_id, status: "rejected").count

    self.acceptance_percentage = ((accepted.to_f / (accepted.to_f + rejected.to_f)) * 100)

    if accepted == 0 and rejected == 0
      puts "This is the first time we have suggested this possibility to you."
    elsif acceptance_percentage >= 0 && acceptance_percentage < 50
      puts "---Your acceptance percentage for this possibility is: " + Rainbow("#{acceptance_percentage.to_i}%").bright + ". Perhaps you should think twice about rejecting this possibility again."
    elsif acceptance_percentage >= 50 && acceptance_percentage < 75
      puts "---Your acceptance percentage for this possibility is: " + Rainbow("#{acceptance_percentage.to_i}%").bright + ". Not bad! Accept it now and watch it rise!"
    elsif acceptance_percentage >= 75
      puts "---Your acceptance percentage for this possibility is: " + Rainbow("#{acceptance_percentage.to_i}%").bright + ". That's awesome! Keep it up!"
    end

    puts ""

    if average_rating != nil
      puts "---Your average rating for this possibility, on a scale of 1-5, is: " + Rainbow("#{average_rating.round(2)}").bright
    end
  end

#---displays overal acceptance percentage of all possiblites suggested to user
  def self.user_possibility_stats(user_id)
    accepted = Activity.where(user_id: user_id, status: "accepted").count + Activity.where(user_id: user_id, status: "accepted and completed").count + Activity.where(user_id: user_id, status: "accepted but not completed").count

    rejected = Activity.where(user_id: user_id, status: "rejected").count

    acceptance_percentage = ((accepted.to_f / (accepted.to_f + rejected.to_f)) * 100)

    if (accepted == 0 && rejected == 0) || (accepted == nil && rejected == nil)
      puts "Once you have used UPTIME, we'll use this space to display some statistics about how often you accept and reject our suggestions."
    elsif acceptance_percentage >= 0 && acceptance_percentage < 50
      puts "You have accepted " + Rainbow("#{acceptance_percentage.to_i}%").bright + " of the possibilities we have suggested to you so far."
      puts "Do your best to accept our suggestions today, and watch that percentage rise!"
    elsif acceptance_percentage >= 50 && acceptance_percentage < 75
      puts "You have accepted: " + Rainbow("#{acceptance_percentage.to_i}%").bright + " of the possibilities we have suggested to you so far. Nice! Keep it up!"
    elsif acceptance_percentage >= 75
      puts "You have accepted " + Rainbow("#{acceptance_percentage.to_i}%").bright + " of the possibilities we have suggested to you so far. You are killin' it!"
    end
  end

end


  def self.get_random_possibility(limit_place, timeLimit, current_user)
    exclude_poss_array = Activity.where(user_id: current_user.id, exclude: true) || []

    exclude_poss_ids = exclude_poss_array.map {|x| x.possibility_id}.uniq

    if limit_place == "Work"
      location_time_exclude = Possibility.all.select do |possibility|
        possibility.duration_in_minutes.to_i <= timeLimit.to_i && ["Work", nil].include?(possibility.necessary_location)
      end
    elsif limit_place == "Home"
      location_time_exclude = Possibility.all.select do |possibility|
        possibility.duration_in_minutes.to_i <= timeLimit.to_i && ["Home", nil, "Somewhere Else"].include?(possibility.necessary_location)
      end
    elsif limit_place == "Somewhere Else"
      location_time_exclude = Possibility.all.select do |possibility|
        possibility.duration_in_minutes.to_i <= timeLimit.to_i && [nil, "Somewhere Else"].include?(possibility.necessary_location)
      end
    end

    poss_array = location_time_exclude.map{|poss_object| poss_object if !exclude_poss_ids.include?(poss_object.id)}.compact

    poss_array.sample

    end

end
