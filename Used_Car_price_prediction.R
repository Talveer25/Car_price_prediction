usedcar <- read.csv("/Users/talveersingh/Desktop/bus5ca/used_car.csv")
View(usedcar)
summary(usedcar)
#2.A
summary_stats <- sapply(usedcar, function(x) {
  c(mean = mean(x, na.rm = TRUE),     # Calculate mean, ignore NA values
    median = median(x, na.rm = TRUE), # Calculate median, ignore NA values
    max = max(x, na.rm = TRUE),       # Find maximum, ignore NA values
    min = min(x, na.rm = TRUE),       # Find minimum, ignore NA values
    sd = sd(x, na.rm = TRUE))         # Calculate standard deviation, ignore NA values
})
summary_stats

library(e1071)
categorical_vars <- c("body_type", "condition", "engine_cylinders", "fuel_type", "make_name", "maximum_seating", "salvage", "transmission", "wheel_system")
freq_counts <- data.frame(Variable = character(0), Category = character(0), Frequency = numeric(0))

for (var in categorical_vars) {
  freq_table <- table(usedcar[[var]])
  variable_name <- rep(var, length(freq_table))
  categories <- names(freq_table)
  frequencies <- as.vector(freq_table)
  
  freq_counts <- rbind(freq_counts, data.frame(Variable = variable_name, Category = categories, Frequency = frequencies))
}
print(freq_counts)

# 1.c Data transformation from categorical to numeric
#column bodytype
usedcar$sedan_bodytype <- as.numeric(usedcar$body_type == 'Sedan')
usedcar$SUV_bodytype <- as.numeric(usedcar$body_type == 'SUV / Crossover')
usedcar$Hatchback_bodytype <- as.numeric(usedcar$body_type == 'Hatchback')
#Column condition
usedcar$condition <-factor(usedcar$condition, levels = c("Fair","Good","Excellent"), labels=c(0,1,2))
#Column engine_cylinders
usedcar$engine_cylinders <- as.numeric(gsub(" Cylinders", "", usedcar$engine_cylinders))
usedcar$maximum_seating <- as.numeric(gsub(" seats", "", usedcar$maximum_seating))
usedcar$Gasline_fuel <- as.numeric(usedcar$fuel_type =='Gasoline')
usedcar$Hybrid_fuel <- as.numeric(usedcar$fuel_type == 'Hybrid')
usedcar$ Diesel_fuel<- as.numeric(usedcar$fuel_type == 'Diesel')
#Column makename
usedcar$BMW_makename <- as.numeric(usedcar$make_name =='BMW')
usedcar$Ford_makename <- as.numeric(usedcar$make_name == 'Ford')
usedcar$AUdi_makename<- as.numeric(usedcar$make_name == 'Audi')
usedcar$Mercedesbenz_makename <- as.numeric(usedcar$make_name =='Mercedes-Benz')
usedcar$Volkswagen_makename <- as.numeric(usedcar$make_name == 'Volkswagen')
usedcar$Toyota_makename<- as.numeric(usedcar$make_name == 'Toyota')
#Column salvage
usedcar$salvage <-factor(usedcar$salvage, levels = c("FALSE","TRUE"), labels=c(0,1))
#column transmission
usedcar$Automatic_transmission <- as.numeric(usedcar$transmission == 'Automatic')
usedcar$Manual_transmission <- as.numeric(usedcar$transmission == 'Manual')
usedcar$Continuously_Variable_Transmission <- as.numeric(usedcar$transmission == 'Continuously Variable Transmission')
usedcar$Dual_Clutch_Transmission <- as.numeric(usedcar$transmission == 'Dual Clutch')
#Column wheel_system 
usedcar$Rear_Wheel_system <- as.numeric(usedcar$wheel_system  == 'Rear-Wheel Drive')
usedcar$All_Wheel_system  <- as.numeric(usedcar$wheel_system  == 'All-Wheel Drive')
usedcar$Front_Wheel_system  <- as.numeric(usedcar$wheel_system  == 'Front-Wheel Drive')
usedcar$Four_Wheel_system  <- as.numeric(usedcar$wheel_system  == 'Four-Wheel Drive')

#2.b
numerical_vars <- c("price", "city_fuel_economy", "daysonmarket", "engine_displacement", "horsepower", "highway_fuel_economy", "mileage", "year", "owner_count")
par(mfrow = c(3, 3))  # Set the layout to 3 rows and 3 columns
for (var in numerical_vars) {
  hist(usedcar[[var]], main = var, col = "blue", border = "black")}

for (var in numerical_vars) {
  boxplot(usedcar[[var]], main = var, col = "red", border = "black")}
#Removing categorical valiables
usedcar$back_legroom <- NULL
usedcar$body_type <- NULL
usedcar$front_legroom<- NULL
usedcar$fuel_type <- NULL
usedcar$fuel_tank_volume <- NULL
usedcar$height <- NULL
usedcar$length<- NULL
usedcar$make_name <- NULL
usedcar$transmission <- NULL
usedcar$wheel_system<- NULL
usedcar$wheelbase <- NULL
usedcar$width <- NULL
View(usedcar)

#4.A
# Check for any NAs in the dataframe. Below function returns the sum of 
# missing values per each column

colSums(is.na(usedcar))
missing_value <- data.frame(price = usedcar$price,city_fuel_economy = usedcar$city_fuel_economy,
  daysonmarket = usedcar$daysonmarket,
  engine_displacement = usedcar$engine_displacement, horsepower = usedcar$horsepower,highway_fuel_economy = usedcar$highway_fuel_economy,
  mileage = usedcar$mileage,owner_count= usedcar$owner_count,year = usedcar$year)
# a) Lets start by replacing all NAs with 0, any issues?
all.zeros <-missing_value
is.na(all.zeros)
all.zeros[is.na(all.zeros)] <- 0
all.zeros[is.na(all.zeros)]
summary(all.zeros)
pairs.panels(all.zeros, col="red")
#Has anything changed?
mean(all.zeros$city, na.rm = TRUE)
mean(missing_value$city_fuel_economy, na.rm = TRUE)
mean(all.zeros$mileage, na.rm = TRUE)
mean(missing_value$mileage, na.rm = TRUE)
# 2) Lets try deleting all rows which have some missing values, 
all.deleted <- missing_value[complete.cases(missing_value),]
summary(all.deleted)
pairs.panels(all.deleted, col="red")
# Has anything changed?
mean(all.deleted$city_fuel_economy, na.rm = TRUE)
mean(missing_value$city_fuel_economy, na.rm = TRUE)
mean(all.deleted$mileage, na.rm = TRUE)
mean(missing_value$mileage, na.rm = TRUE)
# 3) Lets try method 3, replacing all NAs with the mean of each column.
cleaning_data <- missing_value
# We will work with selected column city_fuel_economy & mileage
summary(cleaning_data$city_fuel_economy) # How many NAs in city_fuel_economy
summary(cleaning_data$mileage) # How many NAs in mileage
mean(cleaning_data$city_fuel_economy, na.rm = TRUE) # What is column mean
mean(cleaning_data$mileage, na.rm = TRUE)
is.na(cleaning_data$city_fuel_economy) # What column locations have NAs
is.na(cleaning_data$mileage) # What column locations have NAs
cleaning_data$city_fuel_economy[is.na(cleaning_data$city_fuel_economy)]
cleaning_data$mileage[is.na(cleaning_data$mileage)]
# Let use replace missing values with the mean
cleaning_data$city_fuel_economy[is.na(cleaning_data$city_fuel_economy)] <- 0
cleaning_data$city_fuel_economy[is.na(cleaning_data$city_fuel_economy)] <- mean(cleaning_data$city_fuel_economy, na.rm = TRUE) # Now NAs replaced with mean
summary(cleaning_data$city_fuel_economy) # See if any NAs are still left
cleaning_data$mileage[is.na(cleaning_data$mileage)] <- 0
cleaning_data$mileage[is.na(cleaning_data$mileage)] <- mean(cleaning_data$mileage, na.rm = TRUE) # Now NAs replaced with mean
summary(cleaning_data$mileage) # See if any NAs are still left
# Show the difference
# For City_Fuel_Economy
plot(density(cleaning_data$city_fuel_economy), col="red", #xlim=c(-5, 30), ylim=c(0, 0.6), 
     main="City_fuel_economy")
lines(density(cleaning_data$city_fuel_economy, na.rm = TRUE), col="blue")
lines(density(cleaning_data$city_fuel_economy, na.rm = TRUE), col="orange")
lines(density(cleaning_data$city_fuel_economy, na.rm = TRUE), col="green")

# For Mileage
plot(density(cleaning_data$mileage), col="red", #xlim=c(-5, 30), ylim=c(0, 0.6), 
     main="Mileage")
lines(density(cleaning_data$mileage, na.rm = TRUE), col="blue")
lines(density(cleaning_data$mileage, na.rm = TRUE), col="orange")
lines(density(cleaning_data$mileage, na.rm = TRUE), col="green")
View(cleaning_data)
# Question-5
#a
library(corrplot)
cor.plot(cleaning_data,numbers = TRUE)

corplotclean <- cor(cleaning_data)
round(corplotclean, digits = 3)
corrplot(corplotclean, method = "circle")
#b
target <- cleaning_data$price
# delete the target variable
target <- cleaning_data$price

# delete the target variable 
library(GGally)
library(caret)
delete_target <- subset(cleaning_data, select = -c(price))
ggcorr(delete_target, label=TRUE)

correlation_matrix <- cor(cleaning_data)
correlation_matrix
highlyCorrM <- findCorrelation(correlation_matrix, cutoff=0.5)
names(delete_target)[highlyCorrM]
#removing variables
delete_target_selected = subset(delete_target, select = -c(owner_count, year, engine_displacement, highway_fuel_economy))
View(delete_target_selected)
ggcorr(delete_target_selected, label=TRUE)
delete_target_selected$price <- target
View(delete_target_selected)
# C) 

# Scatter-plot for City Fuel Economy vs. Price
ggplot(delete_target_selected, aes(x = city_fuel_economy, y = price)) +
  geom_point() +
  labs(x = "City Fuel Economy", y = "price") +
  ggtitle("Scatterplot: City Fuel Economy Vs Price ")

#  Scatterplot for daysonmarket vs. Price
ggplot(delete_target_selected, aes(x = daysonmarket, y = price)) +
  geom_point() +
  labs(x = "daysonmarket", y = "Price") +
  ggtitle("Scatterplot:daysonmarket vs. Price")
#  Scatterplot for mileage vs. Price
ggplot(delete_target_selected, aes(x = mileage, y = price)) + geom_point() +labs(x = "Mileage", y = "Price") +
ggtitle("Scatterplot:mileage vs. Price")
#  Scatterplot for horsepower vs. Price
ggplot(delete_target_selected, aes(x = horsepower, y = price)) + geom_point() +labs(x = "horsepower", y = "Price") +
  ggtitle("Scatterplot:horsepower vs. Price")

#Part- C


# Split the dataset into training and testing sets
set.seed(123)  # for reproducibility
train_indices <- sample(1:nrow(cleaning_data), 0.8 * nrow(cleaning_data))
train_data <- cleaning_data[train_indices, ]
test_data <- cleaning_data[-train_indices, ]

# Build a linear regression model
model <- lm(price ~ city_fuel_economy+daysonmarket+mileage+horsepower, data = train_data)

# Make predictions on the test set
predictions <- predict(model, newdata = test_data)

# Evaluate the model using evaluation metrics
# Calculate Mean Absolute Error (MAE)
mae <- mean(abs(predictions - test_data$price))

# Calculate Root Mean Squared Error (RMSE)
rmse <- sqrt(mean((predictions - test_data$price)^2))

# Calculate R-squared (R2)
r_squared <- summary(model)$r.squared

# Print the evaluation metrics
cat("Mean Absolute Error (MAE):", mae, "\n")
cat("Root Mean Squared Error (RMSE):", rmse, "\n")
cat("R-squared (R2):", r_squared, "\n")

# PARTC  Q1 PART B
# Model 1: Original Features
model1 <- lm(price ~city_fuel_economy+daysonmarket+mileage+horsepower, data = train_data)

# Make predictions on the test set
predictions1 <- predict(model1, newdata = test_data)

# Calculate evaluation metrics
mae1 <- mean(abs(predictions1 - test_data$price))
rmse1 <- sqrt(mean((predictions1 - test_data$price)^2))
r_squared1 <- summary(model1)$r.squared
# Model 2: Reduced Features
model2 <- lm(price ~city_fuel_economy+daysonmarket+mileage, data = train_data)

# Make predictions on the test set
predictions2 <- predict(model2, newdata = test_data)

# Calculate evaluation metrics
mae2 <- mean(abs(predictions2 - test_data$price))
rmse2 <- sqrt(mean((predictions2 - test_data$price)^2))
r_squared2 <- summary(model2)$r.squared
# Model 3: Extended Features
model3 <- lm(price ~city_fuel_economy+daysonmarket+mileage+horsepower+ engine_displacement+ owner_count+ year , data = train_data)

# Make predictions on the test set
predictions3 <- predict(model3, newdata = test_data)

# Calculate evaluation metrics
mae3 <- mean(abs(predictions3 - test_data$price))
rmse3 <- sqrt(mean((predictions3 - test_data$price)^2))
r_squared3 <- summary(model3)$r.squared

# Create a data frame to store evaluation metrics
metrics <- data.frame(
  Model = c("Model 1 (Original)", "Model 2 (Reduced)", "Model 3 (Extended)"),
  MAE = c(mae1, mae2, mae3),
  RMSE = c(rmse1, rmse2, rmse3),
  R_squared = c(r_squared1, r_squared2, r_squared3)
)
# Print the evaluation metrics for each model
print(metrics)

# PARTC  Q2 PART A
library(rpart)
library(rpart.plot)
# Split the dataset into training and testing sets
set.seed(123)  # for reproducibility
train_indices <- sample(1:nrow(cleaning_data), 0.8 * nrow(cleaning_data))
train_data <- cleaning_data[train_indices, ]
test_data <- cleaning_data[-train_indices, ]

# Build a decision tree model
model <- rpart(price ~ city_fuel_economy+daysonmarket+mileage+horsepower, data = train_data)

# Plot the decision tree
rpart.plot(model, box.palette = "auto")




