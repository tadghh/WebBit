import { application } from "./application";

import TabsController from "./tabs_controller";
application.register("tabs", TabsController);

import DropdownController from "./dropdown_controller";
application.register("dropdown", DropdownController);
