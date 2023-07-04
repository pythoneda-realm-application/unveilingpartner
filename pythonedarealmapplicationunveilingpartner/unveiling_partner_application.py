"""
pythonedarealmapplicationunveilingpartner/unveiling_partner_application.py

This file can be used to run UnveilingPartner's PythonEDA realm.

Copyright (C) 2023-today rydnr's pythoneda-realm-application/unveilingpartner

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""
from pythonedarealminfrastructureunveilingpartner.hydrated_unveiling_partner import HydratedUnveilingPartner
from pythonedaapplication.pythoneda import PythonEDA

import asyncio

class UnveilingPartnerApplication(PythonEDA):
    """
    Runs the UnveilingPartner's PythonEDA realm.

    Class name: UnveilingPartnerApplication

    Responsibilities:
        - Runs the UnveilingPartner's PythonEDA realm.

    Collaborators:
        - Command-line handlers from pythoneda-realm-infrastructure/unveilingpartner
    """
    def __init__(self):
        """
        Creates a new UnveilingPartnerApplication instance.
        """
        super().__init__(__file__)

    async def accept_master_password(self, passwd: str):
        """
        Accepts the master password.
        :param passwd: The password.
        :type passwd: str
        """
        HydratedUnveilingPartner.set_master_password(passwd)
        HydratedUnveilingPartner.initialize()


if __name__ == "__main__":

    asyncio.run(UnveilingPartnerApplication.main())
