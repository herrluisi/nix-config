{
  services.logind.settings.Login = {
    # don’t shutdown when power button is short-pressed
    HandlePowerKey="ignore";

    # Suspend if the laptop lid is closed
#    HandleLidSwitch="suspend";

    # Suspend after 10 minutes of user inactivity
#    IdleAction="suspend";
#    IdleActionSec="10min";
  };
}
