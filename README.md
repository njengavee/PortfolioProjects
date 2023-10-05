# Data cleaning in Pandas

In this task, we are going to perform do a few data cleaning techniques using pandas. We will be using [customer call list](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbmlJMTZTTWZ6WExjTDA2aGdva1ZCTkFYSFFKQXxBQ3Jtc0ttNjdmcnJqU2RYUU1USVZRNDhlZnpxb2w4d3FQa2JORXc3VmZfd1NqemhmX1BiRnVCMmRKREtkRkg4eURHVGlQMDd0bGtJOGk0SnZyRjBYY29ROHhmSUVzWFJhTUVjalNPWEhxVk9IeDNhWkVFQ1UwZw&q=https%3A%2F%2Fgithub.com%2FAlexTheAnalyst%2FPandasYouTubeSeries%2Fblob%2Fmain%2FCustomer%2520Call%2520List.xlsx&v=bDhvCp3_lYw) dataset to come up with a clean dataset without any missing values, duplicates or outliers. Here's a step-by-step approach of how to go about it:

## Importing data

First, let us load our dataframe using the following code:

``` python
import pandas as pd
df = pd.read_excel(r'C:\Users\PC\Downloads\Customer call list.xlsx')
df
```

Here's the sample output:

![My Image](Images/code1.png)

## Removing duplicates

Next we will remove any duplicates from the dataframe. This is how we will go about it:

``` python
#drop duplicates
df = df.drop_duplicates()
df
```

## Removing unnecessary columns

We will remove any columns that we don't need. This is how to do it:

```python
# delete unnecessary columns
df = df.drop(columns=("Not_Useful_Column"))
df
```

## Eliminating special characters from the values in the 'Last_Name' column

We will use the strip method for this as shown in the code below:

```python
# remove special characters using strip method
df["Last_Name"] = df["Last_Name"].str.strip("123._/")
df
```

## Use replace method to clean the Phone_Number column

We start by removing the non numerical values, the use the lambda method and convert each value in the column 'Phone_Number' to string. Then we will add dashes '-' to the phone numbers. Finally replace the non numeric values within this column with blanks. This is demonstrated in the following code:

```python

# remove all non numeric values
df['Phone_Number'] = df['Phone_Number'].str.replace('[^a-zA-Z0-9]','')

# convert each value into a string
df['Phone_Number'] = df['Phone_Number'].apply(lambda x: str(x))

# adding '-' to the phone numbers
df['Phone_Number'] = df['Phone_Number'].apply(lambda x: x[0:3] + '-' + x[3:6] + '-' + x[6:10])

#replacing non numeric characters with a blank
df['Phone_Number'] = df['Phone_Number'].str.replace('--','')
df['Phone_Number'] = df['Phone_Number'].str.replace('Na','')
df['Phone_Number'] = df['Phone_Number'].str.replace('nan','')
df
```

## Splitting the Address into different columns

```python
# split address
df[['Street_Address', 'State', 'Zip_Code']] = df['Address'].str.split(',', 2, expand=True)
df
```

## Make values uniform

We will then make the values in the 'Paying Customer' and 'Do_Not_Contact' columns uniform by replacing 'Yes' with 'Y' and 'No' with 'N'

 ```python
 #replace Yes with Y in the paying customer column
df['Paying Customer'] = df['Paying Customer'].str.replace('Yes', 'Y')

#replace No with N in the paying customer column
df['Paying Customer'] = df['Paying Customer'].str.replace('No', 'N')

#replace Yes with Y in the Do_Not_Contact column
df['Do_Not_Contact'] = df['Do_Not_Contact'].str.replace('Yes', 'Y')

#replace No with N in the Do_Not_Contact column
df['Do_Not_Contact'] = df['Do_Not_Contact'].str.replace('No', 'N')
df
```

## Replacing the null values with blanks

```python
# Replacing null values with blanks
df = df.fillna('')
df
```

## Eliminating unwanted rows

This step will remove the rows of customers who preferred not to be contacted to remain with those that gave their phone numbers and consent to be contacted.

We will loop through the 'Do_Not_Contact' column and drop every row with a 'Y' as demonstrated in the fllowing code:

```python
# Remove rows where customers who preferred not to be contacted
for x in df.index:
    if df.loc[x,"Do_Not_Contact"] == 'Y':
        df.drop(x, inplace=True)

# Remove rows where the Phone_Number column is not given
for x in df.index:
    if df.loc[x,"Phone_Number"] == '':
        df.drop(x, inplace=True)
df
```

## Reset the index

Finally, we will reset the index to show exactly how many people they called as illustrated in the following code:

```python
# Reset the index
df = df.reset_index(drop=True)
df
```
