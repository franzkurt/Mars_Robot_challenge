# It script not accept any argument for hour
if($args.Length -ne 0)
{
  "Number of arguments > 0 but this script doesn't accept args"
  exit
}

# Search for a Input file in the same folder
$InputPath = 'Input.txt'
if(-Not (Test-Path $InputPath))
{
  "Cannot find the path: $InputPath. Exiting the application"
  exit
}

# Retrieve the content of an input file filtering out empty lines
$Content = Get-Content $InputPath | Where {($_ -ne '')}
if($Content -eq $Null)
{
  "Cannot retrieve the content from path: $InputPath. Exiting the application"
  exit
}

# Split the first line of content in tokens
$Limits = $Content[0].Split(' ')
# Use base 10 to convert a string to an integer and set the limits of matrix
# MAXIMUM Y
[int]$LimitY = ([convert]::ToInt32($Limits[0], 10))
# MAXIMUM X
[int]$LimitX = ([convert]::ToInt32($Limits[1], 10))

# Set the number of rovers in the Mars plateau.
# In this case is two
$RoverNumbers = 2

# Set the first position and run the command string to each one of rovers
for($i=1; $i -le $RoverNumbers; $i++)
{
  # $i is the index of rover
  # Get position and orientation line split in tokens (Even lines)
  $InitPositions = $Content[($i*2)-1].Split(' ')

  # Store Initial Position in X and Y axis
  # To increment or decrement a position is necessary convert it to an integer
  [int]$PositionX = ([convert]::ToInt32($InitPositions[0], 10))
  [int]$PositionY = ([convert]::ToInt32($InitPositions[1], 10))
  # Store the initial position
  [char]$Orientation = $InitPositions[2]

  # Get command line (Odd lines)
  $StringCommand = $Content[$i*2]
  # Interpreting the command string like an array of char
  Foreach($Letter in $StringCommand[0..$StringCommand.Length])
  {
    # Move over matrix
    if($Letter -eq 'M')
    {
      # UP
      if($Orientation -eq 'N')
      {
        if($PositionY -lt $LimitY)
        {
          $PositionY += 1;
        }
      }
      # RIGTH
      elseif($Orientation -eq 'E')
      {
        if($PositionY -lt $LimitX)
        {
          $PositionX += 1;
        }
      }
      # DOWN
      elseif($Orientation -eq 'S')
      {
        if($PositionY -gt 0)
        {
          $PositionY -= 1;
        }
      }
      # LEFT
      elseif($Orientation -eq 'W')
      {
        if($PositionX -gt 0)
        {
          $PositionX -= 1;
        }
      }
      # If first set of orientation was invalid, enter here
      else
      {
        "Orientation: $Orientation is not valid to move. The rover will not move."
      }
    }
    # Set a new orientation
    else
    {
      # Array to set the new orientation
      $CardinalPoints = ('N','E','S','W')

      # Get current orientation like pivot on $CardinalPoints array
      $CurrentOrientationIndex = $CardinalPoints.Indexof("$Orientation")
      if($CurrentOrientationIndex -eq (-1))
      {
        "Index of orientation $Orientation was not found on cardinal points array"
        exit
      }
      # Validation of '$Letter' variable is case sensitive. So 'n' is not equal 'N' in comparison
      if(($Letter -eq 'R') -or ($Letter -eq 'L'))
      {
        # Pointer to the next orientation
        $NextIndex = ''
        # Change the orientation of rover using a circle array
        # Each command can change the orientation in 90 degrees only, not more
        if($Letter -eq 'R')
        {
          # MAX INDEX 3
          if($CurrentOrientationIndex -lt 3)
          {
            $NextIndex = $CurrentOrientationIndex+1
          }
          # RETURN TO INDEX 0
          else
          {
            $NextIndex = 0
          }
        }
        # $Letter equal 'L'
        else
        {
          # MIN INDEX 0.
          if($CurrentOrientationIndex -gt 0)
          {
            $NextIndex = $CurrentOrientationIndex-1
          }
          # RETURN TO INDEX 3
          else
          {
            $NextIndex = 3
          }
        }
        $Orientation = $CardinalPoints[$NextIndex]
      }
      else
      {
        # Alert some error in command string
        "Invalid orientation can not be set with letter [$Letter]"
      }
    }
    # Store the final position of the rover on matrix followed by the orientation
    $FinalPosition = "$PositionX $PositionY $Orientation"
  }
  # Add the result like the content of Output.txt file
  $FinalPosition | Add-Content 'Output.txt'
}
