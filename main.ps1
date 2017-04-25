# Call only the executable path.
# It script not accept any argument for hour
if($args.Length -ne 0)
  {
    "Number of arguments > 0 but this script doesn't accept args"
    exit
  }
$InputPath = 'Input.txt'
if(-Not (Test-Path $InputPath))
{
  "Cannot find the path: $InputPath. Exiting the application"
  exit
}
# Retrieve the content from file filtering out empty lines
$Content = Get-Content $InputPath | Where {($_ -ne '')}
# Split the first lines in tokens using spaces
$Limits = $Content[0].Split(' ')
# Use base 10 to convert a string to integer
[int]$LimitY = ([convert]::ToInt32($Limits[0], 10))
[int]$LimitX = ([convert]::ToInt32($Limits[1], 10))

# Set the number of rovers in the Mars plateau. In this case is two
$RoverNumbers = 2
# Execute the positioning and command string to each one
for($i=1; $i -le $RoverNumbers; $i++)
{
  # Get position and orientation line (Even lines)
  $InitPositions = $Content[($i*2)-1].Split(' ')

  # Store Initial Position in X and Y axis
  [int]$PositionX = ([convert]::ToInt32($InitPositions[0], 10))
  [int]$PositionY = ([convert]::ToInt32($InitPositions[1], 10))
  # Store the initial position
  [char]$Orientation = $InitPositions[2]

  # Get command line (Odd lines)
  $StringCommand = $Content[$i*2]

  # Interpreting the command string
  Foreach($Letter in $StringCommand[0..$StringCommand.Length])
  {
    $Letter |out-host
    # Move over matrix
    if($Letter -eq 'M')
    {
      # UP
      if($Orientation -eq 'N')
      {
        if($PositionY -ne $LimitY)
        {
          $PositionY += 1;
        }
      }
      # RIGTH
      elseif($Orientation -eq 'E')
      {
        if($PositionY -ne $LimitX)
        {
          $PositionX += 1;
        }
      }
      # DOWN
      elseif($Orientation -eq 'S')
      {
        if($PositionY -ne 0)
        {
          $PositionY -= 1;
        }
      }
      # LEFT
      elseif($Orientation -eq 'W')
      {
        if($PositionX -ne 0)
        {
          $PositionX -= 1;
        }
      }
      # If first set of orientation was invalid, enter here
      else
      {
        "Orientation is not valid to move"
      }
    }
    # Set a new orientation
    else
    {
      # Array to set the new orientation
      $CardinalPoints = ('N','E','S','W')
      # Array to validate the input command letter
      $ValidRotation = ('R','L')
      # Validation is case sensitive so 'n' is not equal 'N'
      if($ValidRotation.Contains($Letter))
      {
        if($Letter -eq 'R')
        {
          # Change the orientation of rover
          $Orientation =
        }
        else
        {

        }
      }
      else
      {
        # Alert some error in command string
        "Invalid orientation can not be set with letter [$Letter]"
      }
    }
    # Store the final position of the rover on matrix followed by the orientation
    $FinalPosition = $PositionX + ' ' + $PositionY + ' ' + $Orientation
    # Put result on a file named Output.txt
    $FinalPosition | Add-Content Output.txt
  }
}
